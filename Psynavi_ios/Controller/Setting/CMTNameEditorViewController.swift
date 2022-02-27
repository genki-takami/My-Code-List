/*
 コメントネームの変更・確認画面の処理
 */

import UIKit

final class CMTNameEditViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var currentCommentName: UILabel!
    @IBOutlet private weak var newCommentName: UITextField!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /// 既に保存した名前があれば表示する
        if let commentName = UserDefaultsTask.getUserData("commentName") {
            currentCommentName.text = commentName
        } else {
            currentCommentName.text = "匿名"
        }
        
        setDismissKeyboard()
    }
    
    // MARK: - コメントネームを変更する
    @IBAction private func changeCommentName(_ sender: Any) {
        
        guard let name = newCommentName.text else { return }
        
        if name.isEmpty {
            Modal.showError("新しいコメントネームを入力して下さい")
        } else {
            UserDefaultsTask.setUserData(name, "commentName")
            currentCommentName.text = name
            Modal.showSuccess("コメントネームを更新しました！")
        }
    }
}
