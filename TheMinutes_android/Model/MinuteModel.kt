package jp.seikei.judo.genki.takami.theminutesapp
/*
議事録データのモデル
 */
import java.io.Serializable
import java.util.Date
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class MinuteModel : RealmObject(), Serializable {

    var meetingName: String =  ""        // 会議名
    var minuteTaker: String =  ""        // 書記
    var topic: String =  ""              // 議題
    var dateAndTime: Date = Date()       // 日時
    var place: String =  ""              // 場所
    var attendee: String =  ""           // 出席者
    var meetingContents: String =  ""    // 会議内容
    var decision: String =  ""           // 決定事項
    var note: String =  ""               // 備考
    var parentGroupId: Int = 0           // 親フォルダの特定

    @PrimaryKey
    var id: Int = 0                      // ID
}