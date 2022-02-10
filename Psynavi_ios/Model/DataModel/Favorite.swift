/*
 お気に入り登録したオブジェクトをデータベースに格納するモデル
 */

import RealmSwift

class Favorite: Object{
    
    // uuid
    @objc dynamic var id = ""

    // お気に入り判定
    @objc dynamic var isFavorite = false

    // 文化祭名
    @objc dynamic var festivalName = ""
    
    // 日時
    @objc dynamic var festivalDate = ""
    
    // 開催場所
    @objc dynamic var festivalPlace = ""

    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
