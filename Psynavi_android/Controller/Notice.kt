package jp.creative.primefunc.genki.takami.psynavi
/*
お知らせタブの処理
 */
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import io.realm.Realm
import io.realm.RealmResults
import jp.creative.primefunc.genki.takami.psynavi.databinding.NoticeBinding

class Notice : Fragment() {

    // 変数
    lateinit var adapter: NoticeAdapter
    lateinit var db: FirebaseFirestore
    lateinit var realm: Realm
    lateinit var results: RealmResults<FavoriteModel>
    private var _binding: NoticeBinding? = null
    var noticeArray = ArrayList<Map<String,Any>>()
    val binding get() = _binding!!

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // データベースの設定
        db = Firebase.firestore
        realm = Realm.getDefaultInstance()
    }

    // レイアウトの設定
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = NoticeBinding.inflate(inflater, container, false)
        return binding.root
    }

    // レイアウトの作成
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        // アダプターの設定
        adapter = NoticeAdapter(view.context)

        // 降順に並び替える
        results = realm.where(FavoriteModel::class.java).findAll()
        var receiveCount = results.size
        if (results.isNotEmpty()){
            for (i in results){
                db.collection("NOTICE")
                    .document(i.id)
                    .get()
                    .addOnSuccessListener { document ->
                        val data = document.data
                        if (data != null){
                            // データを取得
                            val noticeIdArray = document.get("list") as ArrayList<String>
                            for (j in noticeIdArray){
                                var datum = data[j] as Map<String,Any>
                                datum += "fesName" to i.festivalname
                                noticeArray.add(datum)
                            }
                            if (receiveCount == 1){ sortingList() }
                        } else {
                            // データが存在しない
                            if (receiveCount == 1){ sortingList() }
                        }
                        // 受信したデータの処理が終了
                        receiveCount -= 1
                    }
                    .addOnFailureListener {
                        val hud = CustomHUD(context = view.context, text = "データ受信に失敗しました")
                        hud.dialog.show()
                    }
            }
        } else {
            // お気に入りがない
            reloadList()
        }

        super.onViewCreated(view, savedInstanceState)
    }

    // レイアウトの更新
    private fun reloadList(){
        binding.NoticeList.adapter = adapter
        adapter.notifyDataSetChanged()
    }

    // 並び替える
    private fun sortingList(){
        // 受信したすべてのお知らせデータを並び替える
        val sortedList = ArrayList<Map<String,Any>>()
        for (notice in noticeArray){
            val timeStamp = notice["date"] as com.google.firebase.Timestamp
            val date = timeStamp.toDate()
            if (sortedList.isNotEmpty()){
                // 並び替えの処理
                for ((index3,value) in sortedList.withIndex()){
                    val existTimeStamp = value["date"] as com.google.firebase.Timestamp
                    val date2 = existTimeStamp.toDate()
                    if (date.after(date2)){
                        // 挿入する
                        sortedList.add(index3,notice)
                        break
                    } else if (index3 == sortedList.lastIndex) {
                        // 最後列に追加する
                        sortedList.add(notice)
                    }
                }
            } else {
                // 最初の挿入
                sortedList.add(notice)
            }
        }
        adapter.noticeArray = sortedList
        reloadList()
    }

    // フラグメントの破棄
    override fun onDestroyView() {
        // ローカルデータベースのシャットダウン
        this.realm.close()

        super.onDestroyView()
        _binding = null
    }
}