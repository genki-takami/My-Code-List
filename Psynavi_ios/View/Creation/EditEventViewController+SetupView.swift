/*
 EditEventViewControllerの拡張
 */

import UIKit

extension EditEventViewController {
    
    /// UIのセットアップ
    func setupView() {
        
        if !event.eventTitle.isEmpty {
            /// 編集のセットアップ
            eventName.text = event.eventTitle
            eventContent.text = event.caption
            eventDate.text = event.eventDate
        }
        
        setDismissKeyboard()
        
        /// コレクションビューにロングタップを追加
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPressAction))
        imageCollection.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func onLongPressAction(sender: UILongPressGestureRecognizer) {
        
        let point: CGPoint = sender.location(in: imageCollection)
        let indexPath = imageCollection.indexPathForItem(at: point)
        
        if let indexPath = indexPath {
            let message = "ロングタップした画像とそのキャプションを削除しますか？"
            let alertController = UIAlertController(title: "画像を削除", message: message, preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "削除", style: .default){ action in
                /// 削除する
                let data: [String:Any] = [
                    "deleteProcess": true,
                    "index": indexPath.row,
                ]
                
                RealmTask.add(self.event, data, EditMode.modify, RealmModel.event) { result in
                    switch result {
                    case .success(_):
                        Modal.showSuccess("削除完了！")
                        self.imageCollection.reloadData()
                    case .failure(_):
                        Modal.showError("削除に失敗！")
                    }
                }
            }
            let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            
            alertController.addAction(actionYes)
            alertController.addAction(actionCancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}
