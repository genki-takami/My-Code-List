/*
 EditMainViewControllerの拡張
 */

import UIKit

extension EditMainViewController: EditMainViewSubMethod2 {
    
    /// 保存するかの確認を表示
    func saveCheck() {
        
        guard let name = name.text else { return }
        
        let message = "\(name)に関係するすべてのデータの保存"
        let alertController = UIAlertController(title: "下書き保存しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "保存", style: .default) { action in
            
            Modal.show()
            /// 条件をクリアできたらFiresbaseにプッシュ
            if self.savingData(name) {
                self.successCount = 0.1
                self.pushFirebase()
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// 削除するのかの確認を表示
    func deleteCheck() {
        
        let message = "\(name.text ?? "＜名前がありません＞")に関係するすべてのデータとアカウントの削除"
        let alertController = UIAlertController(title: "削除しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "削除", style: .destructive) { action in
            
            Modal.show()
            /// データベースから削除
            self.deleteTemporaryData()
            /// アカウントを削除する
            if let user = AuthModule.currentUser() {
                AuthModule.deleteUser(user) { result in
                    switch result {
                    case .success(let text):
                        /// 作成などタブに戻る
                        self.backToTabbar(at: 3)
                        Modal.showSuccess(text)
                    case .failure(let error):
                        Modal.showError(String(describing: error))
                        return
                    }
                }
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    /// 公開するのかの確認を表示
    func releaseCheck() {
        
        if saveData.festivalName.isEmpty {
            Modal.showError("公開する前に保存を必ず行って下さい")
            return
        }
        
        let message = "\(saveData.festivalName)をアプリ上で公開"
        let alertController = UIAlertController(title: "公開しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "公開", style: .default) { action in
            
            Modal.show()
            
            /// 投票オプション(アプリ内課金の状態)
            let upgradeStatus = UserDefaultsTask.getPersonalData(self.saveData.uuid)
            
            /// 公開データ
            let mainData: [String:Any] = [
                "owner" :  self.accountName.text ?? "NO-NAME",
                "festivalName" : self.saveData.festivalName,
                "date" : self.saveData.date,
                "school" : self.saveData.school,
                "slogan" : self.saveData.slogan,
                "info" : self.saveData.info,
                "latitude" : self.saveData.latitude,
                "longitude" : self.saveData.longitude,
                "link" : [
                    "title1" : self.saveData.title1,
                    "url1" : self.saveData.url1,
                    "title2" : self.saveData.title2,
                    "url2" : self.saveData.url2,
                ],
                "upgrade" : upgradeStatus,
            ]
            /// DRAFTデータ
            let draftData: [String:Any] = [
                "upgrade" : upgradeStatus,
                "database" :  [
                    "published" : true,
                ],
            ]
            
            PostData.releaseUpdate(self.saveData.festivalName, self.saveData.uuid, mainData, draftData) { result in
                switch result {
                case .success(_):
                    self.finishUpload()
                case .failure(let error):
                    Modal.showError(String(describing: error))
                    return
                }
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
}
