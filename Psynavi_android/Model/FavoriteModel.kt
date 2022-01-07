package jp.creative.primefunc.genki.takami.psynavi
/*
お気に入りオブジェクトのデータモデル
 */
import io.realm.RealmObject
import io.realm.annotations.PrimaryKey
import java.io.Serializable

open class FavoriteModel: RealmObject(), Serializable {

    var festivalname: String = ""      // 文化祭名
    var date: String = ""              // 日付
    var school: String = ""            // 場所
    var isFavorited: Boolean = false   // お気に入り判定

    @PrimaryKey
    var id: String = ""                // ID
}