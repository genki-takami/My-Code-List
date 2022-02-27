/*
 EditMainViewControllerの拡張
 */

import RealmSwift
import FirebaseStorage

extension EditMainViewController: PostFirebase {
    
    /// Firebaseにアップロード
    func pushFirebase() {
        
        /// 必要なデータを全て参照する
        let conditionalExpression = "mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'"
        let contents = (RealmTask.findAll(RealmModel.content) as! Results<ShopDisplay>).filter(conditionalExpression)
        let notices = (RealmTask.findAll(RealmModel.notice) as! Results<Notices>).filter(conditionalExpression)
        let events = (RealmTask.findAll(RealmModel.event) as! Results<Event>).filter(conditionalExpression)
        let mapData = (RealmTask.findAll(RealmModel.map) as! Results<Map>).filter(conditionalExpression).first ?? Map()
        if mapData.id == "init" {
            mapData.latitude = saveData.latitude
            mapData.longitude = saveData.longitude
        }
        
        /// 達成度10%
        progressView.setProgress(successCount, animated: true)
        
        /// データを構築
        let values = buildDocumentData(contents, notices, events, mapData)
        /// コンテンツとイベントの画像をアップロードする際に必要なプロパティのボックス
        let neededBox: [Any] = [contents, events, values[0], values[2]]
        
        /// バッチ処理
        PostData.batchProcessing(values, saveData, isNewObject!) { result in
            switch result {
            case .success(_):
                /// 達成度30%
                self.stepBar()
                self.uploadIcon(neededBox)
            case .failure(let error):
                Modal.showError(String(describing: error))
                self.progressView.setProgress(0.0, animated: true)
            }
        }
    }
    
    /// Storageにアイコンをアップロードする
    private func uploadIcon(_ defaultNeededBox: [Any]) {
        
        /// データIDにもとずくパスを取得
        let imgRef = FetchData.getReference(saveData.uuid)
        /// メタデータ設定
        let storageMetadata = FetchData.prepareMetadata()
        /// neededBoxに追加する
        var neededBox = defaultNeededBox
        neededBox.append(storageMetadata)
        
        /// アイコン画像
        PostData.imageUpload(imgRef, PathName.FestivalIconImagePath, saveData.iconImage, storageMetadata) { result in
            switch result {
            case .success(_):
                self.successCount += 0.1
                self.progressView.setProgress(self.successCount, animated: true) /// 40%
                /// 背景画像をアップロードする
                self.uploadBackgroundImage(imgRef, storageMetadata, neededBox)
            case .failure(let error):
                Modal.showError(String(describing: error))
                self.progressView.setProgress(0.0, animated: true)
                return
            }
        }
    }
    
    /// Storageに背景画像をアップロードする
    private func uploadBackgroundImage(_ imgRef: StorageReference, _ storageMetadata: StorageMetadata, _ neededBox: [Any]) {
        
        PostData.imageUpload(imgRef, PathName.FestivalBackgroundImagePath, saveData.backgroundImage, storageMetadata) { result in
            switch result {
            case .success(_):
                self.successCount += 0.1
                self.progressView.setProgress(self.successCount, animated: true) /// 50%
                /// コンテンツとイベントの画像をアップロードする
                self.uploadOtherImages(imgRef, neededBox)
            case .failure(let error):
                Modal.showError(String(describing: error))
                self.progressView.setProgress(0.0, animated: true)
                return
            }
        }
    }
}
