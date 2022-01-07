package jp.seikei.judo.genki.takami.theminutesapp
/*
出席者リストのアダプター
 */
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView

class MemberAdapter(context: Context): BaseAdapter() {

    // 変数
    val inflater: LayoutInflater
    var memberList = mutableListOf<MemberModel>()

    // 初期化処理
    init {
        this.inflater = LayoutInflater.from(context)
    }

    // リストの数を返す
    override fun getCount(): Int {
        return memberList.size
    }

    // リストのデータを返す
    override fun getItem(position: Int): MemberModel {
        return memberList[position]
    }

    // リストのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // リストの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val view: View = convertView ?: inflater.inflate(android.R.layout.simple_list_item_1, parent, false)

        val memberName = view.findViewById<TextView>(android.R.id.text1)

        memberName.text = getItem(position).memberName

        return view
    }
}