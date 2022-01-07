package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツのお知らせリストのアダプター
 */
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView

class ReadingNoticeAdapter(context: Context): BaseAdapter() {

    // 変数
    var inflater: LayoutInflater
    var noticeList = mutableListOf<Map<String,Any>>()

    // 初期化処理
    init {
        this.inflater = LayoutInflater.from(context)
    }

    // セルの数を返す
    override fun getCount(): Int {
        return noticeList.size
    }

    // セルのデータを返す
    override fun getItem(position: Int): Map<String,Any> {
        return noticeList[position]
    }

    // セルのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // セルの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val view: View = convertView ?: inflater.inflate(R.layout.reading_notice_cell,parent,false)

        // オブジェクトを取得
        val title = view.findViewById<TextView>(R.id.noticeTitle)
        val date = view.findViewById<TextView>(R.id.noticeDate)
        val content = view.findViewById<TextView>(R.id.noticeContent)

        // データを挿入
        title.text = getItem(position)["noticeTitle"] as String
        content.text = getItem(position)["noticeContent"] as String
        date.text = getItem(position)["date"] as String

        return view
    }
}