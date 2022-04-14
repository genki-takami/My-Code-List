/*
 Firebase関係の処理
 */

import FirebaseFirestore
import FirebaseStorage

final class FetchData {
    
    static let firestore = Firestore.firestore()
    static let storage = Storage.storage().reference()
    
    static func fetchDocument(_ uid: String, handler: @escaping ResultHandler<EventModel>) {
            
        firestore.collection("EVENTS").whereField("list", arrayContains: uid).limit(to: 1).getDocuments(){ (querySnapshot, error) in
            
            if let _ = error {
                handler(.failure(FirebaseError.fetchError))
            } else {
                if querySnapshot!.isEmpty {
                    handler(.failure(FirebaseError.existError))
                } else {
                    let doc = querySnapshot!.documents[0]
                    let event = doc.data()[uid] as! [String:Any]
                    let folderName = event["eventTitle"] as! String
                    let captions = event["imageCaptions"] as! [String]
                    var imageURLArray = [Int:URL]()
                    var refArray = [Int:StorageReference]()
                    
                    if !captions.isEmpty {
                        /// 画像が１つ以上アップロードされている
                        var taskCounter = captions.count
                        /// タスクカウンターを使って画像URLを逐次ダウンロード
                        for (index, caption) in captions.enumerated() {
                            /// キャプションの最初の10文字がファイル名
                            let fileName = String(caption.prefix(10) + ".jpg")
                            /// 画像URLをダウンロード
                            downloadImageURL(id: doc.documentID, dir: "event-image", event: folderName, fileName: fileName) { result in
                                switch result {
                                case .success(let urlString):
                                    imageURLArray[index] = URL(string: urlString)
                                    refArray[index] = storage.child(doc.documentID).child("event-image").child(folderName).child(fileName)
                                    taskCounter -= 1
                                    /// タスクカウンターがゼロになったらキャプション順にURLリストとリファレンスリストを作成し、EventModelを作成する
                                    if taskCounter == 0 {
                                        var imageBox = [EventImage]()
                                        for (i, _) in captions.enumerated() {
                                            let tuple = (imageURLArray[i]!, refArray[i]!)
                                            let eventImage = EventImage(isNewImage: false, downloadImage: tuple, uploadImage: nil)
                                            imageBox.append(eventImage)
                                        }
                                        handler(.success(createEventModel(docID: doc.documentID, uid: uid, event: event, imageBox: imageBox)))
                                    }
                                case .failure(let error2):
                                    handler(.failure(error2))
                                }
                            }
                        }
                    } else {
                        /// まだ画像を一つもアップロードしていない
                        handler(.success(createEventModel(docID: doc.documentID, uid: uid, event: event, imageBox: [EventImage]())))
                    }
                }
            }
        }
    }
    
    static func downloadImageURL(id root: String, dir directory: String, event eventTitle: String, fileName file: String, handler: @escaping ResultHandler<String>) {
        
        let ref = storage.child(root).child(directory).child(eventTitle).child(file)
        ref.downloadURL() { url, error in
            if let _ = error {
                handler(.failure(FirebaseError.downloadError))
            } else {
                guard let urlString = url?.absoluteString else { fatalError() }
                handler(.success(urlString))
            }
        }
    }
    
    static func downloadVideoURL(docID collection: String, fileName file: String, handler: @escaping ResultHandler<URL>) {
        
        let ref = storage.child(collection).child("event-video").child(file)
        ref.downloadURL() { url, error in
            if let _ = error {
                handler(.failure(FirebaseError.videoDownloadError))
            } else {
                guard let url = url else { fatalError() }
                handler(.success(url))
            }
        }
    }
    
    private static func createEventModel(docID: String, uid: String, event: [String:Any], imageBox: [EventImage]) -> EventModel {
        return EventModel(
            documentID: docID,
            uid: uid,
            eventTitle: event["eventTitle"] as! String,
            eventDate: event["eventDate"] as! String,
            caption: event["caption"] as! String,
            imageCaptions: event["imageCaptions"] as! [String],
            upgrade: event.keys.contains("upgrade") ? event["upgrade"] as! Bool : false,
            video: event.keys.contains("video") ? event["video"] as! Bool : false,
            imageBox: imageBox
        )
    }
}
