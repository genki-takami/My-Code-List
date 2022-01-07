package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツのイベント詳細画面の処理
 */
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.recyclerview.widget.GridLayoutManager
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.ktx.storage
import jp.creative.primefunc.genki.takami.psynavi.databinding.ReadingEventContentBinding

class ReadingEventContent : AppCompatActivity() {

    // 変数
    lateinit var obj: Map<String,Any>
    lateinit var adapter: ReadingEventGridAdapter
    lateinit var binding: ReadingEventContentBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ReadingEventContentBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // データの取得
        val fesId = intent.getStringExtra("objectId")
        val data = intent.getSerializableExtra("eventData")
        if (data is MarkerData){
            obj = data.data
        }
        val videoExist = obj["video"] as Boolean
        val eventTitle = obj["eventTitle"] as String
        val eventDate = obj["eventDate"] as String
        val caption = obj["caption"] as String
        val imgCaptions = obj["imageCaptions"] as ArrayList<String>

        // 画像データの挿入
        var checkCount = 0
        val imageCollection = ArrayList<CollectionModel>()
        val ref = Firebase.storage.reference.child(fesId!!).child("event-image").child(eventTitle)
        for (i in imgCaptions){
            val path = i.substring(0,10) + ".jpg"
            val fullPath = ref.child(path)
            fullPath.downloadUrl.addOnSuccessListener { Uri ->
                val imageURL = Uri.toString()
                val instance = CollectionModel(imageURL,"詳細",i)
                imageCollection.add(instance)
                checkCount += 1
                if (checkCount == imgCaptions.size){
                    // グリッド画像の表示準備
                    adapter = ReadingEventGridAdapter(imageCollection)
                    binding.gridRecyclerView.adapter = adapter
                    binding.gridRecyclerView.layoutManager = GridLayoutManager(this,3,GridLayoutManager.VERTICAL,false)
                }
            }

        }

        // テキストデータの挿入
        binding.name.text = eventTitle
        binding.date.text = eventDate
        binding.captionText.text = caption

        // 動画を再生
        binding.imageView.setOnClickListener {
            if (videoExist){
                val intent = Intent(this@ReadingEventContent, PlayVideo::class.java)
                intent.putExtra("uuid", fesId)
                intent.putExtra("name",eventTitle)
                intent.putExtra("contentOrEvent", false)
                startActivity(intent)
            } else {
                val hud = CustomHUD(context = this@ReadingEventContent, text = "動画が投稿されていません")
                hud.dialog.show()
            }
        }
    }
}
