package jp.seikei.judo.genki.takami.theminutesapp
/*
登録会議場所データのモデル
 */
import java.io.Serializable
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey

open class PlaceModel : RealmObject(), Serializable {

    var placeName: String = ""    // 場所の名前
    var parentGroupId: Int = 0    // 親グループのID

    @PrimaryKey
    var id: Int = 0               // ID
}