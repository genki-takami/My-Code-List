/*
 外傷レポートのデータを保存するためのモデル
 */

import RealmSwift

class Database: Object{
    
    // 管理用id
    @objc dynamic var id = 0
    
    // 負傷者名
    @objc dynamic var injured = ""
    
    // 報告者名
    @objc dynamic var reporter = ""
    
    // 日時
    @objc dynamic var date = Date()
    
    // 場所
    @objc dynamic var spot = ""
    
    // 部位
    @objc dynamic var part = ""
    
    // 医師からの診断名
    @objc dynamic var diagnosis = ""
    
    // 原因
    @objc dynamic var cause = ""
    
    // 後遺症など
    @objc dynamic var aftereffect = ""
    
    // 画像データ
    @objc dynamic var image = Data()
    
    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
