/*
 Firebase関係の処理
 */

import FirebaseFirestore
import FirebaseStorage

final class PostData {
    
    static let firestore = FetchData.firestore
    static let storage = FetchData.storage
    
    static func uploadVideo(docID collection: String, fileName file: String, videoURL url: URL, handler: @escaping ResultHandler<Bool>) {
        /// メタデータ設定
        let videoMetadata = StorageMetadata()
        videoMetadata.contentType = "video/mp4"
        
        /// アップロード
        storage.child(collection).child("event-video").child(file).putFile(from: url, metadata: videoMetadata) { _, error in
            if let _ = error {
                handler(.failure(FirebaseError.videoUploadError))
            } else {
                handler(.success(true))
            }
        }
    }
    
    static func uploadImage(docID collection: String, eventTitle event: String, fileName file: String, imageData data: Data, handler: @escaping ResultHandler<String>) {
        /// メタデータ設定
        let storageMetadata = StorageMetadata()
        storageMetadata.contentType = "image/jpeg"
        
        /// アップロード
        storage.child(collection).child("event-image").child(event).child(file).putData(data, metadata: storageMetadata) { _, error in
            if let _ = error {
                handler(.failure(FirebaseError.imageUploadError))
            } else {
                handler(.success("アップロード完了！"))
            }
        }
    }
    
    static func postDocument(docID document: String, docData data: [String:Any], handler: @escaping ResultHandler<Bool>) {
        firestore.collection("EVENTS").document(document).setData(data, merge: true) { error in
            if let _ = error {
                handler(.failure(FirebaseError.uploadError))
            } else {
                handler(.success(true))
            }
        }
    }
}
