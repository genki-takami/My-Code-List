/*
 Firebase関係の処理
 */

import Foundation
import Firebase

final class PostData {
    
    static let firestore = FetchData.firestore
    private static let database = FetchData.database
    
    static func postDocument<T>(_ data: T, _ col: String, _ doc: String, _ mode: PostMode, handler: @escaping ResultHandler<String>) {
        
        switch mode {
        case .inquiry:
            let postDoc = data as! [String:Any]
            firestore.collection(col).document().setData(postDoc) { error in
                
                if let _ = error {
                    handler(.failure(FirebaseError.postError))
                } else {
                    handler(.success("送信しました"))
                }
            }
        case .comment:
            let postDoc = data as! [String:Any]
            firestore.collection(col).document(doc).setData(postDoc, merge: true) { error in
                
                if let _ = error {
                    handler(.failure(FirebaseError.postError))
                } else {
                    handler(.success("コメントを送信しました"))
                }
            }
        }
    }
    
    static func updateDatabase(_ path1: String, _ path2: String, _ key: String, _ vote: [String:String], handler: @escaping ResultHandler<String>) {
        
        let childUpdates = ["/festivals/\(path1)/\(path2)/votes/\(key)": vote]
        
        database.updateChildValues(childUpdates) { error, _ in
            if let _ = error {
                handler(.failure(FirebaseError.postError))
            } else {
                handler(.success("投票しました"))
            }
        }
    }
}
