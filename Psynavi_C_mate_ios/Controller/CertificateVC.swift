/*
 認証画面
 */

import UIKit
import Firebase
import SVProgressHUD

class CertificateVC: UIViewController {
    
    // 変数
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var inputUID: UITextField!
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
    @IBAction func certificateBtn(_ sender: Any) {
        if self.activateFlag{
            if let id = self.inputUID.text{
                if id.isEmpty{
                    SVProgressHUD.showError(withStatus: "IDを入力して下さい")
                } else {
                    SVProgressHUD.show()
                    let ref = Firestore.firestore().collection("CONTENTS")
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
                                let content = data[id] as! [String:Any]
                                let dic = [
                                    "uid": docID,
                                    "id" : id,
                                    "name": content["name"] as Any,
                                    "date": content["date"] as Any,
                                    "place": content["place"] as Any,
                                    "manager": content["manager"] as Any,
                                    "managerInfo": content["managerInfo"] as Any,
                                    "tag": content["tag"] as Any,
                                    "info": content["info"] as Any,
                                    "upgrade": content.keys.contains("upgrade") ? content["upgrade"] as! Bool : false,
                                    "video": content.keys.contains("video") ? content["video"] as! Bool : false
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
        self.inputUID.text = ""
        
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
        self.statusText.text = "ステータス：編集可能"
        self.statusText.textColor = .green
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue"{
            let editvc:EditVC = segue.destination as! EditVC
            editvc.dic = self.dic
        }
    }
}

