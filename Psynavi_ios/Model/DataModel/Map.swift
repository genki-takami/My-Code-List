/*
 データベースにマップを保存するためのモデル
 */

import RealmSwift

final class Map: Object {
    
    // メールアドレス
    @objc dynamic var mailAdress = ""
    
    // パスワード
    @objc dynamic var password = ""
    
    // 管理用 ID
    @objc dynamic var id = "init"
    
    // 緯度
    @objc dynamic var latitude = 35.681236
    
    // 経度
    @objc dynamic var longitude = 139.767125
    
    // ピンのリスト
    let annotations = List<Annotation>()
        
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
