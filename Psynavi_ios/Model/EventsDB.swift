/*
 データベースにイベントを保存するためのモデル
 */

import RealmSwift

class EventsDB: Object {
    
    // メールアドレス
    @objc dynamic var mailAdress = ""
    
    // パスワード
    @objc dynamic var password = ""
    
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = ""
    
    // イベント名
    @objc dynamic var eventTitle = ""
    
    // イベントの日付
    @objc dynamic var eventDate = ""
    
    // キャプション
    @objc dynamic var caption = ""
    
    // 画像の配列データ
    let images = List<Data>()
    
    // 画像のキャプション
    let imageCaptions = List<String>()

    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}

