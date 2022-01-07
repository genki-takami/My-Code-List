package jp.seikei.judo.genki.takami.theminutesapp
/*
フォルダーデータのモデル
 */
import java.io.Serializable
import java.util.Date
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class FolderModel : RealmObject(), Serializable {

    var groupName: String = "" // フォルダー名
    var date: Date = Date()    // 作成日時

    @PrimaryKey
    var id: Int = 0            // ID
}