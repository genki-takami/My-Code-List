/*
 FetchDataの拡張
 */

import Foundation
import Firebase

extension FetchData {
    
    private static let storage = Storage.storage().reference()
    
    static func getStorageReference(_ directory: String, _ file: String) -> StorageReference {
        return storage.child(directory).child(file)
    }
}
