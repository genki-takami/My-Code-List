package jp.creative.primefunc.genki.takami.psynavi
/*
ホームタブの処理
 */
import android.app.AlertDialog
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.view.inputmethod.InputMethodManager
import android.content.Context
import android.graphics.Color
import android.util.TypedValue
import android.widget.Button
import android.widget.SearchView
import android.widget.TextView
import androidx.fragment.app.Fragment
import com.google.android.material.snackbar.Snackbar
import com.google.firebase.firestore.*
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import jp.creative.primefunc.genki.takami.psynavi.databinding.HomeBinding

class Home : Fragment() {

    // 変数
    lateinit var adapter: HomeAdapter
    lateinit var db: FirebaseFirestore
    lateinit var docList: ArrayList<QueryDocumentSnapshot>
    lateinit var filterList: ArrayList<QueryDocumentSnapshot>
    lateinit var listener: ListenerRegistration
    private var _binding: HomeBinding? = null
    var nameList = ArrayList<String>()
    var matchItems = ArrayList<String>()
    val binding get() = _binding!!

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Firestoreの設定
        db = Firebase.firestore
    }

    // レイアウトの設定
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = HomeBinding.inflate(inflater, container, false)
        return binding.root
    }

    // レイアウトの作成
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        // アダプターを設定
        adapter = HomeAdapter(view.context)

        // データスナップショットのリスナー登録
        listener = db.collection("campus-festival")
            .orderBy("timeStamp", Query.Direction.DESCENDING)
            .limit(20)
            .addSnapshotListener { values, error ->

            error?.let {
                return@addSnapshotListener
            }

            // データのリストを作成
            docList = ArrayList()
            values?.let { v: QuerySnapshot ->
                for (doc in v){
                    docList.add(doc)
                }
            }

            // レイアウトを更新
            reloadList()
        }

        // カタログを取得
        val docRef = db.collection("catalog").document("nameList")
        docRef.get()
            .addOnSuccessListener { document ->
                document.data?.let { catalog ->
                    val list = document.get("list") as ArrayList<String>
                    this.nameList.clear()
                    this.nameList.addAll(list)
                    // 開発者お知らせを受け取る
                    val newsId = catalog["id"] as String
                    val newsletter = catalog["newsletter"] as String
                    val sp = activity?.getSharedPreferences("newsletterID", Context.MODE_PRIVATE)
                    val bool = sp!!.getBoolean(newsId, false)
                    if (!bool){
                        val builder = AlertDialog.Builder(view.context)
                        builder.setTitle("開発者よりお知らせ")
                        builder.setMessage(newsletter)
                        builder.setIcon(R.drawable.slogan)

                        // お知らせ履歴を作る
                        builder.setPositiveButton("閉じる"){_, _ ->
                            sp.edit().putBoolean(newsId, true).commit()
                        }

                        // ダイアログを表示
                        val dialog = builder.create()
                        dialog.show()
                    }
                }
            }
            .addOnFailureListener { Snackbar.make(view,"一部のデータの受信に失敗しました",Snackbar.LENGTH_LONG).show() }

        // 検索フィルターしたデータのリストを作成
        filterList = ArrayList()
        val search = binding.searchView
        // リスナーで入力を監視
        search.setOnQueryTextListener(object: SearchView.OnQueryTextListener {

            // キーボードでエンターをタップ
            override fun onQueryTextSubmit(query: String?): Boolean {
                val str = query ?: ""
                val regex = Regex(query.toString())

                // キーボードを閉じる
                val im = activity?.getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

                // フィルターリストを初期化
                filterList.clear()

                // スナックバーの設定
                val snackbar = Snackbar.make(view,"「${str}」に一致するものはありませんでした。",Snackbar.LENGTH_INDEFINITE)
                snackbar.setAction("再表示"){
                    reloadList()
                    snackbar.dismiss()
                }
                snackbar.view.setBackgroundColor(Color.BLUE)
                val snackText = snackbar.view.findViewById<TextView>(com.google.android.material.R.id.snackbar_text)
                snackText.setTextSize(TypedValue.COMPLEX_UNIT_DIP,18.0f)
                val snackBtn = snackbar.view.findViewById<Button>(com.google.android.material.R.id.snackbar_action)
                snackBtn.setTextColor(Color.MAGENTA)
                snackBtn.setTextSize(TypedValue.COMPLEX_UNIT_DIP,18.0f)

                if (str.isEmpty()){
                    // 0文字の場合は通常のデータリストに戻す
                    reloadList()
                } else {
                    if (docList.isNotEmpty()){
                        // スナップショットを検索
                        for (i in docList.indices){
                            if (regex.containsMatchIn(docList[i].getString("festivalName").toString())){
                                // スナップショットで検索ヒット
                                filterList.add(docList[i])
                            }
                        }
                        // スナップショットにない場合
                        if (filterList.isEmpty()){
                            // 合致リストを初期化
                            matchItems.clear()
                            for (j in nameList.indices){
                                if (regex.containsMatchIn(nameList[j])){
                                    // カタログで検索ヒット
                                    matchItems.add(nameList[j])
                                }
                            }
                            if (matchItems.isNotEmpty()){
                                // クラウドからもってくる
                                var taskCounter = matchItems.size
                                for ((index,k) in matchItems.withIndex()){
                                    db.collection("campus-festival")
                                        .whereEqualTo("festivalName",k)
                                        .get()
                                        .addOnSuccessListener { querySnapshot ->
                                            if (!(querySnapshot.isEmpty)){
                                                for (document in querySnapshot){
                                                    filterList.add(document)
                                                    taskCounter -= 1
                                                    if (index == matchItems.lastIndex && taskCounter == 0){
                                                        filtering()
                                                    }
                                                }
                                            } else {
                                                // すでに削除済み
                                                taskCounter -= 1
                                                if (index == matchItems.lastIndex && taskCounter == 0){
                                                    filtering()
                                                    if (filterList.isEmpty()){
                                                        snackbar.show()
                                                    }
                                                }
                                            }
                                        }
                                        .addOnFailureListener { Snackbar.make(view,"検索に失敗しました。再試行してください。",Snackbar.LENGTH_LONG).show() }
                                }
                            } else {
                                // クラウド上にデータがない
                                filtering()
                                snackbar.show()
                            }
                        } else {
                            // スナップショットにあった場合
                            filtering()
                        }
                    } else {
                        // クラウド上にデータが１つも無い
                        filtering()
                        snackbar.show()
                    }
                }

                return true
            }

            // 入力を即時に監視：無効
            override fun onQueryTextChange(newText: String?): Boolean {
                return false
            }
        })

        super.onViewCreated(view, savedInstanceState)
    }

    // デフォルトリストの読み込み
    fun reloadList(){
        adapter.docList = docList
        binding.HomeList.adapter = adapter
        adapter.notifyDataSetChanged()
    }

    // フィルターを適用
    fun filtering(){
        adapter.docList = filterList
        binding.HomeList.adapter = adapter
        adapter.notifyDataSetChanged()
    }

    // フラグメントの破棄
    override fun onDestroyView() {
        // ローカルデータベースのシャットダウン
        adapter.realm.close()

        super.onDestroyView()
        _binding = null
    }
}