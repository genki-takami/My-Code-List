/*
 Firebase関係の処理
 */

import Foundation
import Firebase

final class FetchData {
    
    private static var listener: ListenerRegistration!
    private static let firestore = Firestore.firestore()
    
    static func isListenerNil() -> Bool {
        listener == nil ? true : false
    }
    
    static func resetListener() {
        listener = nil
    }
    
    static func fetchSnapshot(handler: @escaping ResultHandler<[HomeTabCellData]>) {
        
        var dataArray = [HomeTabCellData]()
        // データを受信
        listener = firestore.collection(PathName.FestivalPath)
                        .order(by: "timeStamp", descending: true)
                        .limit(to: 20).addSnapshotListener() { (querySnapshot, error) in
            if let _ = error {
                handler(.failure(FirebaseError.fetchError))
            } else {
                // 取得したdocumentをもとにfestivalDataを作成し、dataArrayの配列にする。
                dataArray = querySnapshot!.documents.map { document in
                    return HomeTabCellData(document: document)
                }
                handler(.success(dataArray))
            }
        }
    }
    
    static func fetchDocument(_ path1: String, _ path2: String, handler: @escaping ResultHandler<[String:Any]>) {
        
        firestore.collection(path1).document(path2).getDocument { (document, error) in
            
            if let _ = error{
                handler(.failure(FirebaseError.fetchError))
            } else {
                if document!.exists {
                    guard var data = document!.data() else { fatalError() }
                    data["documentID"] = document!.documentID
                    handler(.success(data))
                } else {
                    handler(.failure(FirebaseError.fetchError))
                }
                
            }
        }
    }
    
    static func fetchDocuments(_ path: String, _ field: String, _ item: String, _ limit: Int, handler: @escaping ResultHandler<QuerySnapshot>) {
        
        firestore.collection(path).whereField(field, isEqualTo: item)
                            .limit(to: limit)
                            .getDocuments(){ (querySnapshot, error) in
            // エラー判定
            if let _ = error{
                handler(.failure(FirebaseError.fetchError))
            } else {
                if let snapshot = querySnapshot {
                    handler(.success(snapshot))
                } else {
                    handler(.failure(FirebaseError.fetchError))
                }
            }
        }
    }
}
