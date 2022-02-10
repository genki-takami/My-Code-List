/*
 サインインの処理
 */

import UIKit
import Firebase
import SVProgressHUD

class SignInViewController: UIViewController {

    // 変数
    @IBOutlet weak var mailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var accountList: UITextView!
    var pullObject: SaveData!
    var contentImageArray: [String] = [], eventImageArray: [String] = []
    var upgrade: Bool!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // サインインしていたらサインアウトする
        if let _ = Auth.auth().currentUser{
            try! Auth.auth().signOut()
        }
        
        // アカウント履歴がないかチェック
        if let accountList = UserDefaults.standard.stringArray(forKey: "accountList"){
            self.accountList.text = "アカウントの作成履歴\n"
            for i in accountList{
                let str = self.accountList.text
                // 履歴を追加していく
                self.accountList.text = str! + "・" + i + "\n"
            }
        }
        
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // サインイン
    @IBAction func signIn(_ sender: Any) {
        if let address = mailAdress.text, let password = password.text {

            // アドレスとパスワード名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }

            SVProgressHUD.show(withStatus: "ログインとデータの同期中")
            
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                // エラー判定
                if let _ = error {
                    Analytics.logEvent("error_SignInViewController_signIn", parameters: [AnalyticsParameterItemName:"サインインに失敗" as String])
                    SVProgressHUD.showError(withStatus: "ログインに失敗しました")
                } else {
                    if let auth = authResult {
                        self.pullData(uid: auth.user.uid, mail: address, pas: password)
                    } else {
                        SVProgressHUD.showError(withStatus: "ログインに失敗しました")
                        try? Auth.auth().signOut()
                    }
                }
            }
        }
    }
    
    // データを持ってくる
    func pullData(uid: String, mail: String, pas: String){
        
        Firestore.firestore().collection(PathName.DraftPath).document(uid).getDocument{ (document, error) in
            
            // エラー判定
            if let _ = error{
                Analytics.logEvent("error_SignInViewController_pullData", parameters: [AnalyticsParameterItemName:"プルデータ取得に失敗" as String])
                SVProgressHUD.showError(withStatus: "データの同期に失敗！再度お試しください")
                try? Auth.auth().signOut()
                return
            }
            
            if document!.exists {
                if let data = document!.data(){
                    self.pullObject = SaveData()
                    self.pullObject.mailAdress = mail
                    self.pullObject.password = pas
                    self.pullObject.uuid = uid
                    self.pullObject.festivalName = data["festivalName"] as? String ?? ""
                    self.pullObject.date = data["date"] as? String ?? ""
                    self.pullObject.school = data["school"] as? String ?? ""
                    self.pullObject.slogan = data["slogan"] as? String ?? ""
                    self.pullObject.info = data["info"] as? String ?? ""
                    let linkArray: [String:String] = data["link"] as? [String:String] ?? ["title1":"", "title2":"", "url1":"", "url2":""]
                    self.pullObject.title1 = linkArray["title1"] ?? ""
                    self.pullObject.url1 = linkArray["url1"] ?? ""
                    self.pullObject.title2 = linkArray["title2"] ?? ""
                    self.pullObject.url2 = linkArray["url2"] ?? ""
                    self.pullObject.latitude = data["latitude"] as? Double ?? 35.681236
                    self.pullObject.longitude = data["longitude"] as? Double ?? 139.767125
                    let database: [String:Any] = data["database"] as! [String:Any]
                    self.pullObject.published = database["published"] as? Bool ?? false
                    self.pullObject.shop = database["shop"] as? Int ?? 0
                    self.pullObject.display = database["display"] as? Int ?? 0
                    self.pullObject.event = database["event"] as? Int ?? 0
                    self.pullObject.marker = database["marker"] as? Int ?? 0
                    self.pullObject.notice = database["notice"] as? Int ?? 0
                    self.pullObject.icon = database["icon"] as? String ?? ""
                    self.pullObject.background = database["background"] as? String ?? ""
                    self.contentImageArray = database["contentImage"] as? [String] ?? []
                    self.eventImageArray = database["eventImage"] as? [String] ?? []
                    self.upgrade = data["upgrade"] as? Bool ?? false
                    
                    SVProgressHUD.dismiss()
                    self.performSegue(withIdentifier: "fromSignInSegue", sender: nil)
                }
            } else {
                SVProgressHUD.showError(withStatus: "データの同期に失敗！再度お試しください")
                try? Auth.auth().signOut()
            }
        }
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "fromSignInSegue" {
            let createViewController:EditMainViewController = segue.destination as! EditMainViewController
            createViewController.mailAdress = self.pullObject.mailAdress
            createViewController.password = self.pullObject.password
            createViewController.saveData = self.pullObject
            createViewController.isNewObject = false
            createViewController.contentImage = self.contentImageArray
            createViewController.eventImage = self.eventImageArray
            createViewController.upgrade = self.upgrade
        }
    }
    
    // タブ画面に戻る
    @IBAction func backToTab(_ sender: Any) {
        // 作成などタブに戻る
        let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        tabBer.modalPresentationStyle = .fullScreen
        tabBer.selectedIndex = 3
        self.present(tabBer, animated: true, completion: nil)
    }
}
