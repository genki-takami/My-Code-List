/*
 データベースにマップのピンを保存するためのモデル
 */

import RealmSwift

final class Annotation: Object {
    
    // 管理用 ID
    @objc dynamic var id = ""
    
    // ピンのタイトル
    @objc dynamic var title = ""
    
    // ピンのサブタイトル
    @objc dynamic var subtitle = ""
    
    // ピンの画像
    @objc dynamic var pinImage = ""
    
    // ピンの緯度
    @objc dynamic var latitude = 35.681236
    
    // ピンの経度
    @objc dynamic var longitude = 139.767125
        
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
