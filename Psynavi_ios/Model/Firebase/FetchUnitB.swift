/*
 FetchDataの拡張
 */

import Foundation
import Firebase

extension FetchData {
    
    private static let storage = Storage.storage().reference()
    
    static func getReference(_ path: String) -> StorageReference {
        return storage.child(path)
    }
    
    static func getStorageReference(_ directory: String, _ file: String) -> StorageReference {
        return storage.child(directory).child(file)
    }
    
    static func getPath3StorageReference(_ directory1: String, _ directory2: String, _ file: String) -> StorageReference {
        return storage.child(directory1).child(directory2).child(file)
    }
    
    static func getPath4StorageReference(_ directory1: String, _ directory2: String, _ directory3: String, _ file: String) -> StorageReference {
        return storage.child(directory1).child(directory2).child(directory3).child(file)
    }
    
    static func downloadVideo(_ ref: StorageReference, handler: @escaping ResultHandler<URL?>) {
        
        ref.downloadURL { url, error in
            if let _ = error {
                handler(.failure(FirebaseError.fetchError))
            } else {
                handler(.success(url))
            }
        }
    }
}
