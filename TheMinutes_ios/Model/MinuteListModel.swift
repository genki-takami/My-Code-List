/*
 議事録ファイルのデータモデル
 */

import RealmSwift

class MinuteListModel: Object {
    //管理用
    @objc dynamic var id = 0
    //フォルダ認識用
    @objc dynamic var folderId = 0
    //会議名
    @objc dynamic var meetingName = ""
    //書記
    @objc dynamic var secretary = ""
    //議題
    @objc dynamic var topic = ""
    //日時
    @objc dynamic var date = Date()
    //場所
    @objc dynamic var place = ""
    //出席者
    @objc dynamic var attendee = ""
    //会議内容
    @objc dynamic var meetingContents = ""
    //決定事項
    @objc dynamic var decision = ""
    //備考
    @objc dynamic var note = ""
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
