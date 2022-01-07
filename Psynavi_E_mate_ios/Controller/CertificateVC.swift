/*
 認証画面
 */

import UIKit
import Firebase
import SVProgressHUD

class CertificateVC: UIViewController {

    // 変数
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var inputID: UITextField!
    var activateFlag = false
    var dic: [String:Any] = [:]

    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SVProgressHUDのセットアップ
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // 認証ボタン
    @IBAction func certificate(_ sender: Any) {
        if self.activateFlag{
            if let id = self.inputID.text{
                if id.isEmpty{
                    SVProgressHUD.showError(withStatus: "IDを入力して下さい")
                } else {
                    SVProgressHUD.show()
                    let ref = Firestore.firestore().collection("EVENTS")
                    let query = ref.whereField("list", arrayContains: id).limit(to: 1)
                    query.getDocuments(){ (querySnapshot, error) in
                        if let _ = error{
                            SVProgressHUD.showError(withStatus: "検索中にエラーが発生しました")
                        } else {
                            if querySnapshot!.isEmpty{
                                SVProgressHUD.showError(withStatus: "コンテンツ未登録か、IDが不正です")
                            } else {
                                let doc = querySnapshot!.documents[0]
                                let docID = doc.documentID
                                let data = doc.data()
                                let event = data[id] as! [String:Any]
                                let dic = [
                                    "uid": docID,
                                    "id" : id,
                                    "eventTitle": event["eventTitle"] as Any,
                                    "eventDate": event["eventDate"] as Any,
                                    "caption": event["caption"] as Any,
                                    "imageCaptions": event["imageCaptions"] as Any,
                                    "upgrade": event.keys.contains("upgrade") ? event["upgrade"] as! Bool : false,
                                    "video": event.keys.contains("video") ? event["video"] as! Bool : false
                                ] as [String : Any]
                                self.dic = dic
                                SVProgressHUD.dismiss()
                                self.performSegue(withIdentifier: "editSegue", sender: nil)
                            }
                        }
                    }
                }
            }
        } else {
            SVProgressHUD.showError(withStatus: "ステータスが「編集不可」です。一度アプリを閉じて下さい。")
        }
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.inputID.text = ""
        
        SVProgressHUD.show()
        let user = Auth.auth().currentUser
        if let _ = user{
            // Active
            self.activate()
        } else {
            // No Active
            Auth.auth().signInAnonymously() { (authResult, error) in
                if let _ = error{
                    SVProgressHUD.showError(withStatus: "エラー：一度アプリを閉じて下さい")
                } else {
                    // 匿名ログイン成功
                    if authResult!.user.isAnonymous{
                        self.activate()
                    }
                }
            }
        }
    }
    
    // アクティベート
    func activate(){
        SVProgressHUD.showSuccess(withStatus: "準備完了！")
        self.activateFlag = true
        self.statusLabel.text = "ステータス：編集可能"
        self.statusLabel.textColor = .green
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue"{
            let editvc:EditVC = segue.destination as! EditVC
            editvc.dic = self.dic
        }
    }
}

