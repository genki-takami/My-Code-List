package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツのショップリストの処理
 */
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import jp.creative.primefunc.genki.takami.psynavi.databinding.ReadingShopBinding

class ReadingShopList : AppCompatActivity() {

    // 変数
    lateinit var sAdapter: ReadingShopAdapter
    lateinit var binding: ReadingShopBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ReadingShopBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // オブジェクトIDを取得
        val fesId = intent.getStringExtra("objectId")
        val data = intent.getSerializableExtra("objectData")

        // アダプターを設定
        sAdapter = ReadingShopAdapter(this@ReadingShopList)

        // データを受信する
        if (data is ShopData){
            val obj = data.data
            sAdapter.shopList = obj
            reloadList()
        }

        // タップ：詳細画面へ遷移
        binding.rShopListView.setOnItemClickListener { parent, _, position, _ ->
            val shop = parent.adapter.getItem(position) as Map<String,Any>
            val intent = Intent(this@ReadingShopList,ReadingShopContent::class.java)
            intent.putExtra("objectId",fesId)
            intent.putExtra("shopData", MarkerData(shop))
            startActivity(intent)
        }
    }

    // 更新
    private fun reloadList(){
        binding.rShopListView.adapter = sAdapter
        sAdapter.notifyDataSetChanged()
    }
}
