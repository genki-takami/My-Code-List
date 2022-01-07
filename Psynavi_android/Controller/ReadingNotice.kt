package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツのお知らせリストの処理
 */
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import jp.creative.primefunc.genki.takami.psynavi.databinding.ReadingNoticeBinding

class ReadingNotice: AppCompatActivity() {

    // 変数
    lateinit var nAdapter: ReadingNoticeAdapter
    lateinit var binding: ReadingNoticeBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ReadingNoticeBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // オブジェクトを取得
        val data = intent.getSerializableExtra("objectData")

        // アダプターを設定
        nAdapter = ReadingNoticeAdapter(this@ReadingNotice)

        // データを受信する
        if (data is NoticeData){
            val obj = data.data
            nAdapter.noticeList = obj
            reloadList()
        }
    }

    // 更新
    private fun reloadList(){
        binding.rNoticeListView.adapter = nAdapter
        nAdapter.notifyDataSetChanged()
    }
}
