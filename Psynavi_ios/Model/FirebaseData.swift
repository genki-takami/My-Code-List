/*
 Firestoreから受け取ったデータをもとにデータ型を作成するファイル
 */

import UIKit
import Firebase
import RealmSwift

class FirebaseData: NSObject{
    
    // 変数
    var uuid, festivalName, date, place: String
    var isFavorite = false
    let realm = try! Realm()
    
    // 初期化
    init(document: QueryDocumentSnapshot){
        self.uuid = document.documentID
        let data = document.data()
        self.festivalName = data["festivalName"] as? String ?? "名無し"
        self.date = data["date"] as? String ?? "日付未定"
        self.place = data["school"] as? String ?? "開催場所未定"
        // データベースからお気に入りかを判定する
        if let rd = realm.objects(RealmData.self).first(where: { $0.id == document.documentID }){
            rd.isFavorite ? (self.isFavorite = true) : (self.isFavorite = false)
        }
    }
}
