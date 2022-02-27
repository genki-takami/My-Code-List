/*
 Firestoreから受け取ったデータをもとにデータ型を作成するファイル
 */

import FirebaseFirestore
import RealmSwift

final class HomeTabCellData: NSObject {
    
    // MARK: - Property
    let uuid: String
    let festivalName: String
    let date: String
    let place: String
    var isFavorite: Bool
    
    // MARK: - Initialize
    init(document: QueryDocumentSnapshot) {
        self.uuid = document.documentID
        let data = document.data()
        self.festivalName = data["festivalName"] as? String ?? "名無し"
        self.date = data["date"] as? String ?? "日付未定"
        self.place = data["school"] as? String ?? "開催場所未定"
        // データベースからお気に入りかを判定する
        let favorites = RealmTask.findAll(RealmModel.favorite) as! Results<Favorite>
        if let _ = favorites.first(where: { $0.id == document.documentID }) {
            self.isFavorite = true
        } else {
            self.isFavorite = false
        }
    }
}
