package jp.creative.primefunc.genki.takami.psynavi
/*
個別の投票処理
 */
import android.content.Context
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import android.widget.BaseAdapter
import android.widget.Switch
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase
import jp.creative.primefunc.genki.takami.psynavi.databinding.VoteForAnyBinding
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

class VoteForAny : AppCompatActivity() {

    // 変数
    lateinit var slAdapter:SelectListAdapter
    lateinit var binding: VoteForAnyBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = VoteForAnyBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // データを取得
        binding.voteTitle.text = intent.getStringExtra("name") ?: "NONE"
        binding.voteInfo.text = intent.getStringExtra("info") ?: "NONE"
        val voteArr = intent.getStringArrayListExtra("lists") ?: ArrayList<String>()
        val singleOrMulti = intent.getBooleanExtra("choise",false)
        val uid = intent.getStringExtra("uid")

        // 単一か複数か
        if (singleOrMulti) {
            binding.choiseState.text = "複数選択可"
        } else {
            binding.choiseState.text = "単一選択"
        }

        // アダプターを設定
        slAdapter = SelectListAdapter(this@VoteForAny)

        // データを設置
        slAdapter.selectList = voteArr
        slAdapter.singleOrMulti = singleOrMulti
        reloadList()

        // 内部データ
        val sp = getSharedPreferences("userVoteRights", Context.MODE_PRIVATE)

        // タップ：投票ボタン
        binding.voteBtn.setOnClickListener {
            if (sp.getBoolean("rightOf${uid}/${binding.voteTitle.text}",false)){
                // すでに投票済み
                val hud = CustomHUD(context = this@VoteForAny, text = "ひとり１票です")
                hud.dialog.show()
            } else {
                // まだ投票していない
                val strArr = slAdapter.selected
                if (strArr.isEmpty()){
                    // 未選択投票
                    val hud = CustomHUD(context = this@VoteForAny, text = "１つ以上選択して下さい")
                    hud.dialog.show()
                } else {
                    // 投票
                    val builder = AlertDialog.Builder(this@VoteForAny)
                    builder.setTitle("投票しますか？")
                    builder.setMessage("１度投票したら、再度投票できません\n(ひとり１票)")
                    builder.setPositiveButton("投票"){_, _ ->
                        // データベースに追加
                        val hud = CustomHUD(context = this@VoteForAny, text = "送信中...")
                        hud.dialog.show()
                        val ref = Firebase.database.reference
                        for ((index,elem) in strArr.withIndex()){
                            val key = UUID.randomUUID().toString()
                            val dateString = SimpleDateFormat("yyyy/MM/dd HH:mm:ss", Locale.JAPANESE).format(Date())
                            val vote = mapOf<String,Any>(
                                "timestamp" to dateString,
                                "vote" to elem
                            )
                            val childUpdates = hashMapOf<String,Any>(
                                "/festivals/${uid}/${binding.voteTitle.text}/votes/${key}" to vote
                            )
                            ref.updateChildren(childUpdates)
                            if (index == strArr.lastIndex){
                                sp.edit().putBoolean("rightOf${uid}/${binding.voteTitle.text}",true).commit()
                                val hud2 = CustomHUD(context = this@VoteForAny, text = "投票しました")
                                hud2.dialog.show()
                            }
                        }
                    }

                    // キャンセル
                    builder.setNegativeButton("キャンセル",null)

                    // ダイアログを表示
                    val dialog = builder.create()
                    dialog.show()
                }
            }
        }
    }

    // 更新
    private fun reloadList(){
        binding.selectList.adapter = slAdapter
        slAdapter.notifyDataSetChanged()
    }
}

class SelectListAdapter(context: Context): BaseAdapter() {

    // 変数
    var inflater: LayoutInflater
    var selectList = ArrayList<String>()
    var singleOrMulti = false
    var selected = ArrayList<String>()

    // 初期化処理
    init {
        this.inflater = LayoutInflater.from(context)
    }

    // セルの数を返す
    override fun getCount(): Int {
        return selectList.size
    }

    // セルのデータを返す
    override fun getItem(position: Int): String {
        return selectList[position]
    }

    // セルのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // セルの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup?): View {
        val view: View = convertView ?: inflater.inflate(R.layout.vote_select_cell,parent,false)

        // オブジェクトを取得
        val title = view.findViewById<TextView>(R.id.selectTitle)
        val switch = view.findViewById<Switch>(R.id.selectSwitch)

        // データを埋め込む
        title.text = getItem(position)
        switch.isChecked = false

        // スイッチのオン・オフを受け取る
        switch.setOnCheckedChangeListener { buttonView, isChecked ->
            if (isChecked){
                if (singleOrMulti){
                    // 複数選択可
                    selected.add(getItem(position))
                } else {
                    // 単一選択
                    if (selected.isEmpty()){
                        selected.add(getItem(position))
                    } else {
                        buttonView.isChecked = false
                        val hud = CustomHUD(context = parent!!.context, text = "この投票は複数選択できません！\n他の選択を解除して下さい")
                        hud.dialog.show()
                    }
                }
            } else {
                selected.remove(getItem(position))
            }
        }

        return view
    }
}