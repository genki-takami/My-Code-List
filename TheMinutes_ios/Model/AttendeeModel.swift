/*
 出席者のデータモデル
 */

import RealmSwift

class AttendeeModel: Object {
    //管理
    @objc dynamic var id = 0
    //フォルダ認識用
    @objc dynamic var folderId = 0
    //出席者名
    @objc dynamic var attendeeName = ""
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
