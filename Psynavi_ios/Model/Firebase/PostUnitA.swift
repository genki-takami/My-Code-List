/*
 Firebase関係の処理
 */

import Foundation
import Firebase

final class PostData {
    
    private static let firestore = Firestore.firestore()
    
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
        }
    }
}
