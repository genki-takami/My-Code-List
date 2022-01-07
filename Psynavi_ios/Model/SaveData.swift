/*
 作成したオブジェクトをデータベースに保存するモデル
 */

import RealmSwift

class SaveData: Object{
    
    // メールアドレス
    @objc dynamic var mailAdress = ""
    
    // パスワード
    @objc dynamic var password = ""
    
    // uuid
    @objc dynamic var uuid = ""

    // 文化祭名
    @objc dynamic var festivalName = ""
    
    // 日付
    @objc dynamic var date = ""
    
    // 学校名
    @objc dynamic var school = ""
    
    // スローガン
    @objc dynamic var slogan = ""
    
    // 説明
    @objc dynamic var info = ""
    
    // アイコン画像
    @objc dynamic var iconImage = Data()
    
    // 背景画像
    @objc dynamic var backgroundImage = Data()
    
    // URLタイトル１
    @objc dynamic var title1 = ""
    
    // URL１
    @objc dynamic var url1 = ""
    
    // URLタイトル２
    @objc dynamic var title2 = ""
    
    // URL２
    @objc dynamic var url2 = ""
    
    // 緯度
    @objc dynamic var latitude = 35.681236
    
    // 経度
    @objc dynamic var longitude = 139.767125
    
    // オブジェクトのデータベース
    @objc dynamic var published = false
    @objc dynamic var shop = 0
    @objc dynamic var display = 0
    @objc dynamic var event = 0
    @objc dynamic var marker = 0
    @objc dynamic var notice = 0
    @objc dynamic var icon = ""
    @objc dynamic var background = ""

    // id をプライマリーキーとして設定
    override static func primaryKey() -> String? {
        return "uuid"
    }
}
