/*
 出席者のデータモデル
 */

import RealmSwift

class Attendee: Object {
    
    /// 管理id
    @objc dynamic var id = NSUUID().uuidString
    
    /// フォルダ認識用
    @objc dynamic var folderId = ""
    
    /// 出席者名
    @objc dynamic var attendeeName = ""
    
    /// id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
