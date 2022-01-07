package jp.creative.primefunc.genki.takami.psynavi
/*
お気に入りタブのリストのアダプター
 */
import android.app.AlertDialog
import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView
import io.realm.Realm

class FavoriteAdapter(context: Context) : BaseAdapter(){

    // 変数
    var inflater: LayoutInflater
    var dataList = mutableListOf<FavoriteModel>()
    var realm: Realm

    // 初期化処理
    init {
        this.inflater = LayoutInflater.from(context)
        this.realm = Realm.getDefaultInstance()
    }

    // セルの数を返す
    override fun getCount(): Int {
        return dataList.size
    }

    // セルのデータを返す
    override fun getItem(position: Int): FavoriteModel {
        return dataList[position]
    }

    // セルのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // セルの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val view: View = convertView ?: inflater.inflate(R.layout.favorite_list, parent, false)

        // オブジェクトを取得
        val festivalName = view.findViewById<TextView>(R.id.festivalName)
        val school = view.findViewById<TextView>(R.id.festivalPlace)
        val date = view.findViewById<TextView>(R.id.festivalDate)

        // データを挿入
        festivalName.text = getItem(position).festivalname
        school.text = getItem(position).school
        date.text = getItem(position).date

        // ロングタップ：削除ダイアログの表示
        view.setOnLongClickListener {
            // ダイアログの設定
            val builder = AlertDialog.Builder(view.context)
            builder.setTitle("削除")
            builder.setMessage("お気に入りから外しますか？")

            // 削除
            builder.setPositiveButton("はい"){_, _ ->
                realm.executeTransaction {
                    realm.where(FavoriteModel::class.java).equalTo("id",getItem(position).id).findFirst()?.let { data: FavoriteModel ->
                        data.deleteFromRealm()
                    }
                }
                dataList.removeAt(position)
                super.notifyDataSetChanged()
            }

            // キャンセル
            builder.setNegativeButton("キャンセル", null)

            // ダイアログを表示
            val dialog = builder.create()
            dialog.show()

            true
        }

        // タップ：コンテンツホーム画面へ遷移
        view.setOnClickListener {
            val intent = Intent(view.context,ReadingHome::class.java)
            intent.putExtra("objectId",getItem(position).id)
            view.context.startActivity(intent)
        }

        return view
    }
}