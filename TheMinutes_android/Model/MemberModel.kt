package jp.seikei.judo.genki.takami.theminutesapp
/*
登録出席者データのモデル
 */
import java.io.Serializable
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class MemberModel : RealmObject(), Serializable {

    var memberName: String = ""  // 出席者の名前
    var parentGroupId: Int = 0   // 親グループのID

    @PrimaryKey
    var id: Int = 0              // ID
}