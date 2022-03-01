/*
 議事録フォルダのデータモデル
 */

import RealmSwift

class Folder: Object {
    
    /// 管理用id
    @objc dynamic var id = NSUUID().uuidString
    
    /// フォルダ名
    @objc dynamic var folderName = ""
    
    /// 日時
    @objc dynamic var date = Date()
    
    /// id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
