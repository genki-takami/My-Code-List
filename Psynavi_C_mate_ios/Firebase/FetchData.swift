/*
 Firebase関係の処理
 */

import FirebaseFirestore
import FirebaseStorage

final class FetchData {
    
    static let firestore = Firestore.firestore()
    static let storage = Storage.storage().reference()
    
    static func fetchDocument(_ uid: String, handler: @escaping ResultHandler<ShopDisplayModel>) {
            
        firestore.collection("CONTENTS").whereField("list", arrayContains: uid).limit(to: 1).getDocuments(){ (querySnapshot, error) in
            
            if let _ = error {
                handler(.failure(FirebaseError.fetchError))
            } else {
                if querySnapshot!.isEmpty {
                    handler(.failure(FirebaseError.existError))
                } else {
                    let doc = querySnapshot!.documents[0]
                    let content = doc.data()[uid] as! [String:Any]
                    let fileName = content["name"] as! String + ".jpg"
                    
                    downloadImageURL(col: doc.documentID, doc: "content-image", fileName: fileName) { result in
                        switch result {
                        case .success(let urlString):
                            let data = ShopDisplayModel(
                                documentID: doc.documentID,
                                uid: uid,
                                name: content["name"] as! String,
                                date: content["date"] as! String,
                                place: content["place"] as! String,
                                manager: content["manager"] as! String,
                                managerInfo: content["managerInfo"] as! String,
                                tag: content["tag"] as! String,
                                info: content["info"] as! String,
                                upgrade: content.keys.contains("upgrade") ? content["upgrade"] as! Bool : false,
                                video: content.keys.contains("video") ? content["video"] as! Bool : false,
                                url: URL(string: urlString)!
                            )
                            handler(.success(data))
                        case .failure(let error2):
                            handler(.failure(error2))
                        }
                    }
                }
            }
        }
    }
    
    static func downloadImageURL(col collection: String, doc document: String, fileName file: String, handler: @escaping ResultHandler<String>) {
        
        let ref = storage.child(collection).child(document).child(file)
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
        
        let ref = storage.child(collection).child("content-video").child(file)
        ref.downloadURL() { url, error in
            if let _ = error {
                handler(.failure(FirebaseError.videoDownloadError))
            } else {
                guard let url = url else { fatalError() }
                handler(.success(url))
            }
        }
    }
}
