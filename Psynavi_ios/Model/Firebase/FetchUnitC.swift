/*
 FetchDataの拡張
 */

import Foundation
import Firebase

extension FetchData {
    
    private static let database = Database.database().reference()
    
    static func fetchDatabase(_ path: String, handler: @escaping ResultHandler<[String:AnyObject]>) {
        
        database.child(path).getData { (error, snapshot) in
            if let _ = error {
                handler(.failure(FirebaseError.fetchError))
            } else if snapshot.exists() {
                // データあり(課金済み)
                if let object = snapshot.value as? [String:AnyObject] {
                    handler(.success(object))
                } else {
                    handler(.failure(FirebaseError.fetchError))
                }
            } else {
                // データなし(課金済み)
                handler(.success([:]))
            }
        }
    }
}
