/*
 Firebase関係の処理
 */

import Foundation
import FirebaseFirestore

extension PostData {
    
    static func receiptUpload(_ uuid: String, _ receiptData: String, handler: @escaping ResultHandler<Bool>) {
        
        let receiptPath = firestore.collection(PathName.ReceiptPah).document(uuid)
        let draftPath = firestore.collection(PathName.DraftPath).document(uuid)
        
        batch.setData(["receiptString": receiptData, "timestamp" : Timestamp(date: Date())], forDocument: receiptPath)
        batch.setData(["upgrade" : true], forDocument: draftPath, merge: true)
        
        batch.commit() { err in
            if let _ = err {
                handler(.failure(FirebaseError.postError))
            } else {
                handler(.success(true))
            }
        }
    }
}
