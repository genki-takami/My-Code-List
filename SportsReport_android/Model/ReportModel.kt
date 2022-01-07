package jp.seikei.judo.genki.takami.reportofsports_injuryapp
/*
レポートデータのモデル
 */
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import java.io.Serializable
import java.util.*

open class ReportModel: RealmObject(), Serializable {

    var person: String = ""         // 負傷者
    var reporter: String = ""       // 報告者
    var dateAndTime: Date = Date()  // 日時
    var place: String = ""          // 場所
    var position: String = ""       // 部位
    var diagnosis: String = ""      // 医師からの診断
    var cause: String = ""          // 原因
    var afterEffect: String = ""    // 後遺症など
    var picture: String = ""        // 画像

    @PrimaryKey
    var id: Int = 0                 // ID
}