/*
 サインアップの処理
 */

import UIKit
import Firebase
import SVProgressHUD

class SignUpViewController: UIViewController {

    // 変数
    @IBOutlet weak var displayName: UITextField!
    @IBOutlet weak var mailAdress: UITextField!
    @IBOutlet weak var password: UITextField!
    var uid: String!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // サインインしていたらサインアウトする
        if let _ = Auth.auth().currentUser{
            try! Auth.auth().signOut()
        }
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // アカウントの作成
    @IBAction func signUp(_ sender: Any) {
        if let address = mailAdress.text, let password = password.text, let displayName = displayName.text {

            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "必要項目を入力して下さい")
                return
            }
            
            SVProgressHUD.show()

            // アドレスとパスワードでユーザー作成。ユーザー作成に成功すると、自動的にログイン
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                // エラー判定
                if let _ = error {
                    Analytics.logEvent("error_user_SignUpViewController_signUp", parameters: [AnalyticsParameterItemName:"ユーザー作成に失敗" as String])
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました")
                    return
                }
                
                // 表示名を設定する
                if let user = authResult?.user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        
                        if let _ = error {
                            Analytics.logEvent("error_name_SignUpViewController_signUp", parameters: [AnalyticsParameterItemName:"表示名の設定に失敗" as String])
                            SVProgressHUD.showError(withStatus: "すでに存在するメールアドレスです")
                        } else {
                            self.uid = user.uid
                            self.performSegue(withIdentifier: "fromSignUpSegue", sender: nil)
                            SVProgressHUD.dismiss()
                        }
                    }
                } else {
                    Analytics.logEvent("error_getuser_SignUpViewController_signUp", parameters: [AnalyticsParameterItemName:"作成したユーザー情報が取得できませんでした" as String])
                    SVProgressHUD.showError(withStatus: "すでに存在するメールアドレスです")
                }
            }
        }
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if segue.identifier == "fromSignUpSegue" {
            let createViewController:CreateViewController = segue.destination as! CreateViewController
            if let mail = self.mailAdress.text, let pass = self.password.text{
                
                let data = SaveData()
                data.mailAdress = mail
                data.password = pass
                data.uuid = self.uid
                
                createViewController.saveData = data
                createViewController.mailAdress = mail
                createViewController.password = pass
                createViewController.isNewObject = true
            }
        }
    }
    
    // タブ画面に戻る
    @IBAction func backToTabFromSignUp(_ sender: Any) {
        // 作成などタブに戻る
        let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        tabBer.modalPresentationStyle = .fullScreen
        tabBer.selectedIndex = 3
        self.present(tabBer, animated: true, completion: nil)
    }
}
