/*
 EditMainViewControllerの拡張
 */

import UIKit
import RealmSwift
import FirebaseStorage

extension EditMainViewController {
    
    // Firebaseにアップロードする
    func pushFirebase() {
        
        // 必要なデータを全て参照する
        let conditionalExpression = "mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'"
        let contents = (DataProcessing.findAll(RealmModel.content) as! Results<ShopDisplay>).filter(conditionalExpression)
        let notices = (DataProcessing.findAll(RealmModel.notice) as! Results<Notices>).filter(conditionalExpression)
        let events = (DataProcessing.findAll(RealmModel.event) as! Results<Event>).filter(conditionalExpression)
        let mapData = (DataProcessing.findAll(RealmModel.map) as! Results<Map>).filter(conditionalExpression).first ?? Map()
        if mapData.id == "init" {
            mapData.latitude = saveData.latitude
            mapData.longitude = saveData.longitude
        }
        
        // 達成度10%
        progressView.setProgress(successCount, animated: true)
        
        // データを構築
        let values = buildDocumentData(contents, notices, events, mapData)
        // コンテンツとイベントの画像をアップロードする際に必要なプロパティのボックス
        let neededBox: [Any] = [contents, events, values[0], values[2]]
        
        // バッチ処理
        PostData.batchProcessing(values, saveData, isNewObject!) { result in
            switch result {
            case .success(_):
                // 達成度30%
                self.stepBar()
                self.iconUpload(neededBox)
            case .failure(let error):
                DisplayPop.error(error.localizedDescription)
                self.progressView.setProgress(0.0, animated: true)
            }
        }
    }
    
    // Storageにアイコンをアップロードする
    private func iconUpload(_ defaultNeededBox: [Any]) {
        
        // データIDにもとずくパスを取得
        let imgRef = FetchData.getReference(saveData.uuid)
        // メタデータ設定
        let storageMetadata = FetchData.prepareMetadata()
        // neededBoxに追加する
        var neededBox = defaultNeededBox
        neededBox.append(storageMetadata)
        
        // アイコン画像
        PostData.imageUpload(imgRef, PathName.FestivalIconImagePath, saveData.iconImage, storageMetadata) { result in
            switch result {
            case .success(_):
                self.successCount += 0.1
                self.progressView.setProgress(self.successCount, animated: true)// 40%
                // 背景画像をアップロードする
                self.backgroundImageUpload(imgRef, storageMetadata, neededBox)
            case .failure(let error):
                DisplayPop.error(error.localizedDescription)
                self.progressView.setProgress(0.0, animated: true)
                return
            }
        }
    }
    
    // Storageに背景画像をアップロードする
    private func backgroundImageUpload(_ imgRef: StorageReference, _ storageMetadata: StorageMetadata, _ neededBox: [Any]) {
        
        PostData.imageUpload(imgRef, PathName.FestivalBackgroundImagePath, saveData.backgroundImage, storageMetadata) { result in
            switch result {
            case .success(_):
                self.successCount += 0.1
                self.progressView.setProgress(self.successCount, animated: true)// 50%
                // コンテンツとイベントの画像をアップロードする
                self.othersUpload(imgRef, neededBox)
            case .failure(let error):
                DisplayPop.error(error.localizedDescription)
                self.progressView.setProgress(0.0, animated: true)
                return
            }
        }
    }
}
