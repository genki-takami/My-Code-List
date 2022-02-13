/*
 データベースにコンテンツを保存するためのモデル
 */

import RealmSwift

final class ShopDisplay: Object {
    
    // メールアドレス
    @objc dynamic var mailAdress = ""
    
    // パスワード
    @objc dynamic var password = ""
    
    // 管理用 ID
    @objc dynamic var id = NSUUID().uuidString
    
    // 店か展示か
    @objc dynamic var switchFlag = true
    
    // 店の名前
    @objc dynamic var name = ""
    
    // 運営団体名
    @objc dynamic var manager = ""
    
    // 日付
    @objc dynamic var date = ""
    
    // 場所
    @objc dynamic var place = ""
    
    // 画像
    @objc dynamic var image = Data()
    
    // タグ
    @objc dynamic var tag = ""
    
    // 情報
    @objc dynamic var info = ""
    
    // 団体情報
    @objc dynamic var managerInfo = ""

    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "id"
    }
}
