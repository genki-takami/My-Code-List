/*
 お問い合わせの処理
 */

import UIKit
import Firebase
import SVProgressHUD

class InquiryViewController: UIViewController {

    // 変数
    @IBOutlet weak var contentsTitle: UITextField!
    @IBOutlet weak var contents: UITextView!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // 送信
    @IBAction func sendContents(_ sender: Any) {
        if let title = contentsTitle.text, let content = contents.text{
            
            if title.isEmpty || content.isEmpty{
                SVProgressHUD.showError(withStatus: "タイトルと内容を記してください！")
            } else {
                SVProgressHUD.show()
                
                let postDoc: [String : Any] = [
                    "title" : title,
                    "content" : content,
                ]
                
                Firestore.firestore().collection(Const.InquiryPath).document().setData(postDoc){ err in
                    // エラー判定
                    if let _ = err {
                        Analytics.logEvent("error_InquiryViewController_sendContents", parameters: [AnalyticsParameterItemName:"お問い合わせ内容の送信失敗" as String])
                        SVProgressHUD.showError(withStatus: "送信に失敗")
                    } else {
                        SVProgressHUD.showSuccess(withStatus: "送信しました")
                    }
                }
            }
        }
    }
}
