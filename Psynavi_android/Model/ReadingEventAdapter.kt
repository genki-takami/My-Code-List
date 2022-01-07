package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツのイベントリストのアダプター
 */
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView

class ReadingEventAdapter(context: Context): BaseAdapter() {

    // 変数
    var inflater: LayoutInflater
    var eventList = mutableListOf<Map<String,Any>>()

    // 初期化処理
    init {
        this.inflater = LayoutInflater.from(context)
    }

    // セルの数を返す
    override fun getCount(): Int {
        return eventList.size
    }

    // セルのデータを返す
    override fun getItem(position: Int): Map<String,Any> {
        return eventList[position]
    }

    // セルのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // セルの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val view: View = convertView ?: inflater.inflate(R.layout.reading_event_cell,parent,false)

        // オブジェクトを取得
        val title = view.findViewById<TextView>(R.id.name)
        val date = view.findViewById<TextView>(R.id.date)

        // データを挿入
        title.text = getItem(position)["eventTitle"] as String
        date.text = getItem(position)["eventDate"] as String

        return view
    }
}