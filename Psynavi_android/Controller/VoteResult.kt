package jp.creative.primefunc.genki.takami.psynavi
/*
投票の結果を表示する
 */
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import jp.creative.primefunc.genki.takami.psynavi.databinding.VoteResultBinding

class VoteResult : AppCompatActivity() {

    // レイアウトファイルと接合
    lateinit var binding: VoteResultBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = VoteResultBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // データを取得
        val data = intent.getSerializableExtra("resultObject")
        if (data is VoteResultData){
            val obj = data.data
            val allCount = obj.remove("all") as String
            binding.resultTitle.text = "結果（${allCount}）"
            if (obj.isNotEmpty()){
                if (obj.size == 1){
                    val key = obj.keys.elementAt(0)
                    binding.firstTitle.text = key
                    binding.firstPoints.text = "得票数：${obj[key]}票"
                } else if (obj.size > 1){
                    val sortedResult = obj.toList().sortedByDescending { it.second as Long }
                    val first = sortedResult[0]
                    binding.firstTitle.text = first.first
                    binding.firstPoints.text = "得票数：${first.second as Long}票"
                    val second = sortedResult[1]
                    binding.secondTitle.text = second.first
                    binding.secondPoints.text = "得票数：${second.second as Long}票"
                    if (obj.size >2){
                        val third = sortedResult[2]
                        binding.thirdTitle.text = third.first
                        binding.thirdPoints.text = "得票数：${third.second as Long}票"
                    }
                }
            }
        }
    }
}