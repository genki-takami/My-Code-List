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
        
        // 既に保存した名前があれば表示する
        if let commentName = DataProcessing.getUserData("commentName") {
            currentCommentName.text = commentName
        } else {
            currentCommentName.text = "匿名"
        }
        
        let gesture = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: - コメントネームを変更する
    @IBAction private func changeCommentName(_ sender: Any) {
        
        if let name = newCommentName.text {
            
            if name.isEmpty {
                DisplayPop.error("新しいコメントネームを入力して下さい")
            } else {
                DataProcessing.setUserData(name, "commentName")
                currentCommentName.text = name
                DisplayPop.success("コメントネームを更新しました！")
            }
        }
    }
}
