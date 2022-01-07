package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツの投票リストのアダプター
 */
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView

class VoteListAdapter(context: Context): BaseAdapter() {

    // 変数
    var inflater: LayoutInflater
    var voteList = mutableListOf<Map<String,Any>>()

    // 初期化処理
    init {
        this.inflater = LayoutInflater.from(context)
    }

    // セルの数を返す
    override fun getCount(): Int {
        return voteList.size
    }

    // セルのデータを返す
    override fun getItem(position: Int): Map<String,Any> {
        return voteList[position]
    }

    // セルのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // セルの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val view: View = convertView ?: inflater.inflate(android.R.layout.simple_list_item_2,parent,false)

        // オブジェクトを取得
        val textView1 = view.findViewById<TextView>(android.R.id.text1)
        val textView2 = view.findViewById<TextView>(android.R.id.text2)

        // データを挿入
        textView1.text = getItem(position)["name"] as? String ?: "No Title"
        textView2.text = getItem(position)["state"] as? String ?: "作成中"

        return view
    }
}