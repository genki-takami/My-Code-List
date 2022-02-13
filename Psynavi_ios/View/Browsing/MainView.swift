/*
 MainViewControllerの拡張
 */

import UIKit
import FirebaseFirestore
import FirebaseUI

extension MainViewController {
    
    // コメントを送信する時に確認するアラート
    func sendAlert(_ text: String, _ name: String) {
        
        let message = "内容：\(text.prefix(10))・・・"
        let alertController = UIAlertController(title: "送信しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "はい、送信", style: .default) { action in
            
            DisplayPop.show()
            
            let doc: [String:Any] = [
                NSUUID().uuidString: [
                    "sender" :  name,
                    "comment" : text,
                    "timestamp" : Timestamp(date: Date()),
                ]
            ]
            
            PostData.postDocument(doc, PathName.ListCommentID, self.uuid, PostMode.comment) { result in
                switch result {
                case .success(let text2):
                    DisplayPop.success(text2)
                    self.getDocComments()
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // ホームタブに戻る
    func backToHomeTab() {
        let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        tabBer.modalPresentationStyle = .fullScreen
        tabBer.selectedIndex = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.present(tabBer, animated: true, completion: nil)
        }
    }
    
    // アイコン画像と背景画像を設置
    func setIconAndBack() {
        if databaseProperty["icon"] != nil {
            iconImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let iconRef = FetchData.getReference(databaseProperty["icon"] as! String)
            iconImage.sd_setImage(with: iconRef)
        }
        if databaseProperty["background"] != nil {
            backgroundImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let backRef = FetchData.getReference(databaseProperty["background"] as! String)
            backgroundImage.sd_setImage(with: backRef)
        }
    }
}
