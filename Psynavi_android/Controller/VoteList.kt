package jp.creative.primefunc.genki.takami.psynavi
/*
投票リストの処理
 */
import android.os.Bundle
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase
import jp.creative.primefunc.genki.takami.psynavi.databinding.VoteListBinding

class VoteList : AppCompatActivity() {

    // 変数
    private val voteList = ArrayList<Map<String,Any>>()
    private val resultList = ArrayList<MutableMap<String,Any>>()
    lateinit var vAdapter:VoteListAdapter
    lateinit var uid:String
    lateinit var binding: VoteListBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = VoteListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // オブジェクトIDを取得
        this.uid = intent.getStringExtra("objectId")!!

        // 投票ステータスを取得
        val grade = intent.getBooleanExtra("upgrade",false)

        // アダプターを設定
        vAdapter = VoteListAdapter(this@VoteList)

        // データを受信
        if (grade){
            val ref = Firebase.database.reference.child("festivals").child(this.uid)
            ref.get()
                .addOnSuccessListener { document ->
                    (document.value as? Map<String,Any>)?.let {
                        // データあり(課金済み)
                        val keys = it.keys
                        for (key in keys){
                            val event = it[key] as Map<String,Any>
                            // データセットを取得
                            val dataset = event["dataset"] as Map<String,Any>
                            val lists = dataset["lists"] as ArrayList<Map<String,String>>
                            val choises = ArrayList<String>()
                            for (list in lists){
                                choises.add(list["title"] as String)
                            }
                            val voteObject = hashMapOf(
                                "name" to dataset["name"] as String,
                                "info" to dataset["info"] as String,
                                "lists" to choises,
                                "choise" to dataset["choise"] as Boolean,
                                "state" to if (dataset["finish"] as Boolean) "終了" else "実施中"
                            )
                            this.voteList.add(voteObject)
                            // 結果を取得
                            val result = event["result"] as? MutableMap<String,Any>
                            if (result != null){
                                this.resultList.add(result)
                            } else {
                                this.resultList.add(hashMapOf("all" to "Nobody vote"))
                            }
                        }
                        vAdapter.voteList = this.voteList
                    }
                    reloadList()
                }
                .addOnFailureListener {
                    val hud = CustomHUD(context = this@VoteList, text = "データ受信に失敗しました！")
                    hud.dialog.show()
                }
        } else {
            // データなし(非課金)
            reloadList()
        }

        // タップ：詳細画面へ遷移
        binding.voteListView.setOnItemClickListener { parent, _, position, _ ->
            val vote = parent.adapter.getItem(position) as Map<String,Any>
            if (vote["state"] as String == "実施中"){
                val intent = Intent(this@VoteList,VoteForAny::class.java)
                intent.putExtra("name",vote["name"] as String)
                intent.putExtra("info",vote["info"] as String)
                intent.putExtra("lists",vote["lists"] as ArrayList<String>)
                intent.putExtra("choise",vote["choise"] as Boolean)
                intent.putExtra("uid",this.uid)
                startActivity(intent)
            } else if (vote["state"] as String == "終了"){
                val intent = Intent(this@VoteList,VoteResult::class.java)
                val obj = VoteResultData(this.resultList[position])
                intent.putExtra("resultObject",obj)
                startActivity(intent)
            }
        }
    }

    // 更新
    private fun reloadList(){
        binding.voteListView.adapter = vAdapter
        vAdapter.notifyDataSetChanged()
    }
}