package jp.creative.primefunc.genki.takami.psynavi
/*
お知らせタブのリストのアダプター
 */
import android.app.AlertDialog
import android.content.Context
import java.text.SimpleDateFormat
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import java.util.*

class NoticeAdapter(context: Context) : BaseAdapter(){

    // 変数
    var inflater: LayoutInflater
    var db: FirebaseFirestore
    var noticeArray = mutableListOf<Map<String,Any>>()

    // 初期化処理
    init {
        this.inflater = LayoutInflater.from(context)
        this.db = Firebase.firestore
    }

    // セルの数を返す
    override fun getCount(): Int {
        return noticeArray.size
    }

    // セルのデータを返す
    override fun getItem(position: Int): Map<String,Any> {
        return noticeArray[position]
    }

    // セルのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // セルの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        val view: View = convertView ?: inflater.inflate(R.layout.notice_list, parent, false)

        // オブジェクトを取得
        val festivalName = view.findViewById<TextView>(R.id.festivalName)
        val subject = view.findViewById<TextView>(R.id.subject)
        val sendTime = view.findViewById<TextView>(R.id.sendTime)

        // データを挿入
        val fn = getItem(position)["fesName"]
        festivalName.text = fn as String
        val sub = getItem(position)["noticeTitle"] as String
        val str = "件名：${sub}"
        subject.text = str
        val content = getItem(position)["noticeContent"] as String
        val timeStamp = getItem(position)["date"] as com.google.firebase.Timestamp
        sendTime.text = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.JAPANESE).format(timeStamp.toDate())

        // タップ：お知らせの表示
        view.setOnClickListener {
            // ダイアログの設定
            val builder = AlertDialog.Builder(view.context)
            builder.setTitle(sub)
            builder.setMessage(content)
            builder.setIcon(R.drawable.slogan)

            // 確認
            builder.setPositiveButton("OK",null)

            // ダイアログを表示
            val dialog = builder.create()
            dialog.show()
        }

        return view
    }
}