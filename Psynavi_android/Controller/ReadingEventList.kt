package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツのイベントリストの処理
 */
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import jp.creative.primefunc.genki.takami.psynavi.databinding.ReadingEventBinding

class ReadingEventList : AppCompatActivity() {

    lateinit var eAdapter: ReadingEventAdapter
    lateinit var binding: ReadingEventBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ReadingEventBinding.inflate(layoutInflater)
        setContentView(binding.rootView)

        // オブジェクトIDを取得
        val fesId = intent.getStringExtra("objectId")
        val data = intent.getSerializableExtra("objectData")

        // アダプターを設定
        eAdapter = ReadingEventAdapter(this@ReadingEventList)

        // データを受信する
        if (data is EventData){
            val obj = data.data
            eAdapter.eventList = obj
            reloadList()
        }

        // タップ：詳細画面へ遷移
        binding.rEventListView.setOnItemClickListener { parent, _, position, _ ->
            val event = parent.adapter.getItem(position) as Map<String,Any>
            val intent = Intent(this@ReadingEventList,ReadingEventContent::class.java)
            intent.putExtra("objectId",fesId)
            intent.putExtra("eventData", MarkerData(event))
            startActivity(intent)
        }
    }

    // 更新
    private fun reloadList(){
        binding.rEventListView.adapter = eAdapter
        eAdapter.notifyDataSetChanged()
    }
}
