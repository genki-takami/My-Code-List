/*
 EditMainViewControllerの拡張
 */

import UIKit

extension EditMainViewController {
    
    // 公開するのかの確認を表示
    func releaseCheck() {
        
        if saveData.festivalName.isEmpty {
            DisplayPop.error("公開する前に保存を必ず行って下さい")
            return
        }
        
        let message = "\(saveData.festivalName)をアプリ上で公開"
        let alertController = UIAlertController(title: "公開しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "公開", style: .default) { action in
            
            DisplayPop.show()
            
            // 投票オプション(アプリ内課金の状態)
            let upgradeStatus = DataProcessing.getPersonalData(self.saveData.uuid)
            
            // 公開データ
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
            // DRAFTデータ
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
                    DisplayPop.error(error.localizedDescription)
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
