/*
 コメントネームの変更・確認画面の処理
 */

import UIKit
import SVProgressHUD

class CommentNameViewController: UIViewController {
    
    // 変数
    @IBOutlet weak var currentCommentName: UILabel!
    @IBOutlet weak var newCommentName: UITextField!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 既に保存した名前があれば表示する
        if let commentName = UserDefaults.standard.string(forKey: "commentName"){
            currentCommentName.text = commentName
        } else {
            currentCommentName.text = "匿名"
        }
        
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // コメントネームを変更する
    @IBAction func changeCommentName(_ sender: Any) {
        if let name = newCommentName.text{
            
            if name.isEmpty{
                SVProgressHUD.showError(withStatus: "新しいコメントネームを入力して下さい")
            } else {
                UserDefaults.standard.setValue(name, forKey: "commentName")
                self.currentCommentName.text = name
                SVProgressHUD.showSuccess(withStatus: "コメントネームを更新しました！")
            }
        }
    }
}
