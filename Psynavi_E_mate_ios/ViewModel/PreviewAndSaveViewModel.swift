//
//  PreviewAndSaveViewModel.swift
//  Psynavi E-mate
//
//  Created by 髙見元基 on 2022/04/10.
//

import SwiftUI
import FirebaseStorage

final class PreviewAndSaveViewModel: ObservableObject {
    
    @Published var eventName = "コンテンツ名"
    @Published var date = "〇〇月〇〇日〇曜日＠〇〇時〜"
    @Published var caption = "イベントの説明"
    @Published var imageCaptions = [String]()
    @Published var imageBox = [EventImage]()
    @Published var saveLabel = "保存する"
    @Published var isReadyForPlayVideo = false
    @Published var videoURL: URL? = nil
    @Published var onStreaming = false
    @Published var currentBox: EventImage? = nil
    private var documentID = ""
    private var uid = ""
    private var upgrade = false
    private var video = false
    private var deleteList = [StorageReference]()
    
    func setupView(with data: EventModel?, prepare references: [StorageReference]) {
        
        guard let data = data else { return }
        
        eventName = data.eventTitle
        date = data.eventDate
        caption = data.caption
        imageCaptions = data.imageCaptions
        imageBox = data.imageBox
        
        documentID = data.documentID
        uid = data.uid
        upgrade = data.upgrade
        video = data.video
        
        deleteList = references
    }
    
    func getCaption(_ box: EventImage) -> String {
        let index: Int = imageBox.firstIndex(where: { $0.id == box.id })!
        return imageCaptions[index]
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
                    let fileName = eventName + ".mp4"
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
    
    func save(url: URL?) {
            
        Modal.showMessage("アップロード中...")
        
        if let url = url {
            let fileName = eventName + ".mp4"
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
                "caption" : caption,
                "eventTitle" : eventName,
                "eventDate" : date,
                "imageCaptions" : imageCaptions,
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
        var uploads = (imageBox.filter { $0.isNewImage == true }).count
        
        if uploads == 0 {
            /// 新規画像がない
            imageDeleteFromStorage()
        } else {
            /// 新規画像あり
            for (index, box) in imageBox.enumerated() {
                if let image = box.uploadImage {
                    /// JPEGに変換して画像をアップロード
                    let fileName = String(imageCaptions[index].prefix(10) + ".jpg")
                    let imageData = image.jpegData(compressionQuality: 0.75)!
                    
                    PostData.uploadImage(docID: documentID, eventTitle: eventName, fileName: fileName, imageData: imageData) { result in
                        switch result {
                        case .success(_):
                            uploads -= 1
                            if uploads == 0{
                                self.imageDeleteFromStorage()
                            }
                        case .failure(let error):
                            Modal.showError(String(describing: error))
                        }
                    }
                }
            }
        }
    }
    
    private func imageDeleteFromStorage() {
        var deletes = deleteList.count
        
        if deletes >= 1 {
            for imagePath in deleteList {
                DeleteData.deleteImage(path: imagePath) { result in
                    switch result {
                    case .success(_):
                        checkoutTask()
                    case .failure(_):
                        checkoutTask()
                    }
                }
            }
        } else {
            /// 削除する画像がない
            finishTask()
        }
        
        func checkoutTask() {
            deletes -= 1
            if deletes == 0 {
                finishTask()
            }
        }
    }
    
    private func finishTask() {
        Modal.showSuccess("アップロード完了！\n文化祭コンテンツが公開されている場合、「Psyなび for 文化祭&お祭り」アプリで確認できます")
        saveLabel = "保存完了"
    }
}
