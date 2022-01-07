/*
 会議場所のデータモデル
 */

import RealmSwift

class PlaceModel: Object {
    //管理
    @objc dynamic var id = 0
    //フォルダ認識用
    @objc dynamic var folderId = 0
    //会議場所
    @objc dynamic var meetingPlace = ""
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}

