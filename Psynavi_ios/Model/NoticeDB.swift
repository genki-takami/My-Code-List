/*
 データベースにお知らせを保存するためのモデル
 */

import RealmSwift

class NoticeDB: Object {
    
    // メールアドレス
    @objc dynamic var mailAdress = ""
    
    // パスワード
    @objc dynamic var password = ""
    
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = ""
    
    // 件名
    @objc dynamic var noticeTitle = ""
    
    // 内容
    @objc dynamic var noticeContent = ""
    
    // 発信日時
    @objc dynamic var date = Date()

    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
