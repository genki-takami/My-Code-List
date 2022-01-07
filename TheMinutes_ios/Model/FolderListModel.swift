/*
 議事録フォルダのデータモデル
 */

import RealmSwift

class FolderListModel: Object{
    //管理用
    @objc dynamic var id = 0
    //フォルダ名
    @objc dynamic var folderName = ""
    // 日時
    @objc dynamic var date = Date()
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
