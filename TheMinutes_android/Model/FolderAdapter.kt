package jp.seikei.judo.genki.takami.theminutesapp
/*
議事録フォルダーのリストアダプター
 */
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView
import java.text.SimpleDateFormat
import java.util.*

class FolderAdapter(context: Context): BaseAdapter() {

    // 変数
    val inflater: LayoutInflater
    var folderList = mutableListOf<FolderModel>()

    // 初期化処理
    init {
        this.inflater = LayoutInflater.from(context)
    }

    // リストの数を返す
    override fun getCount(): Int {
        return folderList.size
    }

    // リストのデータを返す
    override fun getItem(position: Int): FolderModel {
        return folderList[position]
    }

    // リストのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // リストの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val view: View = convertView ?: inflater.inflate(android.R.layout.simple_list_item_2, parent, false)

        val folderName = view.findViewById<TextView>(android.R.id.text1)
        val timestamp = view.findViewById<TextView>(android.R.id.text2)

        folderName.text = getItem(position).groupName
        timestamp.text = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.JAPANESE).format(getItem(position).date)

        return view
    }
}