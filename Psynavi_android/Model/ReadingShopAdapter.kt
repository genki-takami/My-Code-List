package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツのショップリストのアダプター
 */
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView

class ReadingShopAdapter(context: Context): BaseAdapter() {

    // 変数
    var inflater: LayoutInflater
    var shopList = mutableListOf<Map<String,Any>>()

    // 初期化処理
    init {
        this.inflater = LayoutInflater.from(context)
    }

    // セルの数を返す
    override fun getCount(): Int {
        return shopList.size
    }

    // セルのデータを返す
    override fun getItem(position: Int): Map<String,Any> {
        return shopList[position]
    }

    // セルのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // セルの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val view: View = convertView ?: inflater.inflate(R.layout.reading_shop_cell,parent,false)

        // オブジェクトを取得
        val tag = view.findViewById<TextView>(R.id.tag)
        val fesName = view.findViewById<TextView>(R.id.name)
        val place = view.findViewById<TextView>(R.id.place)
        val manager = view.findViewById<TextView>(R.id.manager)

        // データを挿入
        tag.text = getItem(position)["tag"] as String
        fesName.text = getItem(position)["name"] as String
        place.text = getItem(position)["place"] as String
        manager.text = getItem(position)["manager"] as String

        return view
    }
}