/*
 VoteOperationViewControllerの拡張
 */

import UIKit

extension VoteOperationViewController: VoteData {
    
    /// 投票処理
    func vote(for title: String) {
        
        let message = "１度投票したら、再度投票できません\n(ひとり１票)"
        let alertController = UIAlertController(title: "投票しますか？", message: message, preferredStyle: .alert)
        
        let actionYes = UIAlertAction(title: "投票", style: .default) { action in
            
            Modal.show()
            
            for (index, choise) in self.selected.enumerated() {
                
                let dateFormatter = DateFormatter()
                dateFormatter.calendar = Calendar(identifier: .gregorian)
                dateFormatter.locale = Locale(identifier: "ja_JP")
                dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
                dateFormatter.dateFormat = "yyyy/M/d/ H:mm:ss"
                let dateString = dateFormatter.string(from: Date())
                
                let key = NSUUID().uuidString
                
                let data = [
                    "timestamp" : dateString,
                    "vote" : choise,
                ]
                
                PostData.updateDatabase(self.uid, title, key, data) { result in
                    switch result {
                    case.success(let text):
                        /// 最終処理
                        if index == self.selected.count - 1 {
                            Modal.showSuccess(text)
                            /// 投票履歴をレコード
                            UserDefaultsTask.setPersonalData(true, "rightOf\(self.uid)/\(title)")
                        }
                    case .failure(let error):
                        Modal.showError(String(describing: error))
                    }
                }
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
}
