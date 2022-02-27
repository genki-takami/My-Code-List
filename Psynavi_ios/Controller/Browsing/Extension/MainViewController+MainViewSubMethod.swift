/*
 MainViewControllerの拡張
 */

import UIKit
import SafariServices
import FirebaseFirestore

extension MainViewController: MainViewSubMethod {
    
    /// コメントを送信する時に確認するアラート
    func sendComment(_ text: String, _ name: String) {
        
        let message = "内容：\(text.prefix(10))・・・"
        let alertController = UIAlertController(title: "送信しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "はい、送信", style: .default) { action in
            
            Modal.show()
            
            let doc: [String:Any] = [
                NSUUID().uuidString: [
                    "sender" :  name,
                    "comment" : text,
                    "timestamp" : Timestamp(date: Date()),
                ],
            ]
            
            PostData.postDocument(doc, PathName.ListCommentID, self.uuid, PostMode.comment) { result in
                switch result {
                case .success(let text2):
                    Modal.showSuccess(text2)
                    self.fetchDocComments()
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// ホームタブに戻る
    func backToHomeTab() {
        backToTabbar(at: 0)
    }
    
    /// Safariでサイトを表示
    func showBrowser(_ link: String) {
        if link.isEmpty {
            Modal.showError("Webページが見つかりません")
        } else {
            guard let url = URL(string: link) else { return }
            present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
}
