package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツの展示リストの処理
 */
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import jp.creative.primefunc.genki.takami.psynavi.databinding.ReadingDisplayBinding

class ReadingDisplayList : AppCompatActivity() {

    // 変数
    lateinit var dAdapter: ReadingDisplayAdapter
    lateinit var binding: ReadingDisplayBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ReadingDisplayBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // オブジェクトIDを取得
        val fesId = intent.getStringExtra("objectId")
        val data = intent.getSerializableExtra("objectData")

        // アダプターを設定
        dAdapter = ReadingDisplayAdapter(this@ReadingDisplayList)

        // データを受信する
        if (data is DisplayData){
            val obj = data.data
            dAdapter.displayList = obj
            reloadList()
        }

        // タップ：詳細画面へ遷移
        binding.rDisplayListView.setOnItemClickListener { parent, _, position, _ ->
            val display = parent.adapter.getItem(position) as Map<String,Any>
            val intent = Intent(this@ReadingDisplayList,ReadingDisplayContent::class.java)
            intent.putExtra("objectId",fesId)
            intent.putExtra("displayData", MarkerData(display))
            startActivity(intent)
        }
    }

    // 更新
    private fun reloadList(){
        binding.rDisplayListView.adapter = dAdapter
        dAdapter.notifyDataSetChanged()
    }
}
