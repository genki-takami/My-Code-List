/*
 Firebase関係の処理
 */

import Foundation
import Firebase

extension PostData {
    
    private static let batch = firestore.batch()
    private static let storage = FetchData.storage
    
    private static func getDocumentReference(_ collection: String, _ uid: String) -> DocumentReference {
        return firestore.collection(collection).document(uid)
    }
    
    static func batchProcessing(_ values: [Any], _ saveData: PsyData, _ isNewObject: Bool, handler: @escaping ResultHandler<Bool>) {
        // ドキュメントデータのパスと構築されたデータ
        let uuid = saveData.uuid
        let draftRef = getDocumentReference(PathName.DraftPath, uuid)
        let contentRef = getDocumentReference(PathName.ListContentsID, uuid)
        let eventRef = getDocumentReference(PathName.ListEventsID, uuid)
        let noticeRef = getDocumentReference(PathName.ListNoticeID, uuid)
        let mapRef = getDocumentReference(PathName.ListMapID, uuid)
        let contentsData = values[0] as! [String:Any]
        let contentList = values[1] as! [String]
        let eventsData = values[2] as! [String:Any]
        let eventList = values[3] as! [String]
        let noticesData = values[4] as! [String:Any]
        let noticeList = values[5] as! [String]
        let annotationData = values[6] as! [String:Any]
        let mainData = values[7] as! [String:Any]
        
        // バッチ処理
        if !contentsData.isEmpty {
            batch.setData(contentsData, forDocument: contentRef, merge: true)
            if !isNewObject {
                batch.updateData(["list": FieldValue.arrayUnion(contentList)], forDocument: contentRef)
            }
        }
        if !eventsData.isEmpty {
            batch.setData(eventsData, forDocument: eventRef, merge: true)
            if !isNewObject {
                batch.updateData(["list": FieldValue.arrayUnion(eventList)], forDocument: eventRef)
            }
        }
        if !noticesData.isEmpty {
            batch.setData(noticesData, forDocument: noticeRef, merge: true)
            if !isNewObject {
                batch.updateData(["list": FieldValue.arrayUnion(noticeList)], forDocument: noticeRef)
            }
        }
        if !annotationData.isEmpty {
            batch.setData(annotationData, forDocument: mapRef)
        }
        batch.setData(mainData, forDocument: draftRef, merge: true)
        
        batch.commit() { error in
            if let _ = error {
                handler(.failure(FirebaseError.postError))
            } else {
                handler(.success(true))
            }
        }
    }
    
    static func imageUpload(_ ref: StorageReference, _ path: String, _ imageData: Data, _ metadata: StorageMetadata, handler: @escaping ResultHandler<Bool>) {
        // 画像をひとつずつアップロード
        ref.child(path).putData(imageData, metadata: metadata) { _, error in
            
            if let _ = error {
                handler(.failure(FirebaseError.uploadError))
            } else {
                handler(.success(true))
            }
        }
    }
}
