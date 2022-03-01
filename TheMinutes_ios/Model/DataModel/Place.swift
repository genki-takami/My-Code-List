/*
 会議場所のデータモデル
 */

import RealmSwift

class Place: Object {
    
    /// 管理id
    @objc dynamic var id = NSUUID().uuidString
    
    /// フォルダ認識用
    @objc dynamic var folderId = ""
    
    /// 会議場所
    @objc dynamic var meetingPlace = ""
    
    /// id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}

