/*
 購入画面のViewModel
 */

import SwiftUI

final class PreviewAndSaveViewModel: ObservableObject {
    
    @Published var contentName = "コンテンツ名"
    @Published var manager = "運営団体名"
    @Published var date = "〇〇月〇〇日〇曜日＠〇〇時〜"
    @Published var place = "運営場所"
    @Published var tag = "タグ："
    @Published var info = "ここに説明を書く(100文字以内)"
    @Published var managerInfo = "ここに団体情報を書く(100文字以内)"
    @Published var saveLabel = "保存する"
    @Published var isReadyForPlayVideo = false
    @Published var videoURL: URL? = nil
    @Published var onStreaming = false
    private var documentID = ""
    private var uid = ""
    private var upgrade = false
    private var video = false
    private var isNewImage = false
    private var image: UIImage? = nil
    
    func setupView(with data: ShopDisplayModel?) {
        
        guard let data = data else { return }
        
        contentName = data.name
        manager = data.manager
        date = data.date
        place = data.place
        tag = data.tag
        info = data.info
        managerInfo = data.managerInfo
        
        documentID = data.documentID
        uid = data.uid
        upgrade = data.upgrade
        video = data.video
    }
    
    func playVideo(from url: URL?) {
        let key = uid + "-video"
        if upgrade || UserDefaultsTask.checkPurchased(key) {
            /// 課金済み
            if let url = url {
                /// 端末から動画を参照
                videoURL = url
                isReadyForPlayVideo = true
            } else {
                /// クラウドストレージから参照
                if video {
                    let fileName = contentName + ".mp4"
                    FetchData.downloadVideoURL(docID: documentID, fileName: fileName) { result in
                        switch result {
                        case .success(let cloudURL):
                            self.videoURL = cloudURL
                            self.onStreaming = true
                            self.isReadyForPlayVideo = true
                        case .failure(let error):
                            Modal.showError(String(describing: error))
                        }
                    }
                } else {
                    /// アップグレードしたが動画はまだ投稿していない
                    Modal.showError("動画は投稿されていません")
                }
            }
        } else {
            /// 無課金
            Modal.showError("動画は投稿されていません")
        }
    }
    
    func save(url: URL?, imageBool: Bool, newImage: UIImage?) {
        
        Modal.showMessage("アップロード中...")
        
        isNewImage = imageBool
        image = newImage
        
        if let url = url {
            let fileName = contentName + ".mp4"
            PostData.uploadVideo(docID: documentID, fileName: fileName, videoURL: url) { result in
                switch result {
                case .success(_):
                    self.documentUpload(videoOption: true)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        } else {
            /// 動画はアップロードしない
            video ? documentUpload(videoOption: true) : documentUpload(videoOption: false)
        }
    }
    
    private func documentUpload(videoOption videoBool: Bool) {
        let key = uid + "-video"
        let data: [String: Any] = [
            uid : [
                "name" : contentName,
                "manager" : manager,
                "date" : date,
                "place" : place,
                "tag" : tag,
                "info" : info,
                "managerInfo" : managerInfo,
                "upgrade" : upgrade || UserDefaultsTask.checkPurchased(key) ? true : false,
                "video" : videoBool
            ]
        ]
        
        PostData.postDocument(docID: documentID, docData: data) { result in
            switch result {
            case .success(_):
                self.imageUpload()
            case .failure(let error):
                Modal.showError(String(describing: error))
            }
        }
    }
    
    private func imageUpload() {
        if isNewImage {
            /// 画像をアップロード
            /// JPEGに変換
            let fileName = contentName + ".jpg"
            let imageData = image!.jpegData(compressionQuality: 0.75)!
            PostData.uploadImage(docID: documentID, fileName: fileName, imageData: imageData) { result in
                switch result {
                case .success(let text):
                    Modal.showSuccess(text)
                    self.saveLabel = "保存完了"
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        } else {
            /// 新しい画像をアップロードしない
            Modal.showSuccess("アップロード完了！\n文化祭コンテンツが公開されている場合、「Psyなび for 文化祭&お祭り」アプリで確認できます")
            saveLabel = "保存完了"
        }
    }
}
