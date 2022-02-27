/*
 EditMainViewControllerの拡張
 */

import RealmSwift
import FirebaseStorage

extension EditMainViewController: UploadImages {
    
    /// コンテンツとイベントの画像をアップロードする
    func uploadOtherImages(_ imgRef: StorageReference, _ neededBox: [Any]) {
        
        let contents = neededBox[0] as! Results<ShopDisplay>
        let events = neededBox[1] as! Results<Event>
        let contentsData = neededBox[2] as! [String:Any]
        let eventsData = neededBox[3] as! [String:Any]
        let storageMetadata = neededBox[4] as! StorageMetadata
        
        /// コンテンツ画像
        if !contentsData.isEmpty {
            
            var taskCounter = contents.count
            
            for content in contents {
                let path = PathName.ContentImagePath + "/" + content.name + ".jpg"
                
                PostData.imageUpload(imgRef, path, content.image, storageMetadata) { result in
                    switch result {
                    case .success(_):
                        taskCounter -= 1
                        if taskCounter == 0 {
                            self.stepBar() /// 70%
                        }
                    case .failure(let error):
                        Modal.showError(String(describing: error))
                        self.progressView.setProgress(0.0, animated: true)
                        return
                    }
                }
            }
        } else {
            /// コンテンツなし 70%
            stepBar()
        }
        
        /// イベント画像
        if !eventsData.isEmpty {
            
            var taskCounter = events.count
            var imageTaskCounter = 0
            
            for event in events {
                /// キャプションの配列を作成
                var captionList = [String]()
                for c in event.imageCaptions{
                    captionList.append(c)
                }
                
                taskCounter -= 1
                
                /// 画像の数だけタスクを追加していく
                imageTaskCounter += event.images.count
                if !event.images.isEmpty {
                    
                    for (index, image) in event.images.enumerated() {
                        let path = PathName.EventImagePath + "/" + event.eventTitle + "/" + captionList[index].prefix(10) + ".jpg"
                        
                        PostData.imageUpload(imgRef, path, image, storageMetadata) { result in
                            switch result {
                            case .success(_):
                                imageTaskCounter -= 1
                                if taskCounter == 0 && imageTaskCounter == 0 {
                                    self.stepBar() /// 90%
                                }
                            case .failure(let error):
                                Modal.showError(String(describing: error))
                                self.progressView.setProgress(0.0, animated: true)
                                return
                            }
                        }
                    }
                } else {
                    /// イベントデータはあるが画像がない 90%
                    if taskCounter == 0 && imageTaskCounter == 0 {
                        self.stepBar()
                    }
                }
            }
        } else {
            /// イベント画像なし 90%
            stepBar()
        }
        
        uploadLoop1()
    }
}
