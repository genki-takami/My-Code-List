package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツの展示詳細画面の処理
 */
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.bumptech.glide.Glide
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.ktx.storage
import jp.creative.primefunc.genki.takami.psynavi.databinding.ReadingDisplayContentBinding

class ReadingDisplayContent : AppCompatActivity() {

    // 変数
    lateinit var obj: Map<String,Any>
    lateinit var binding: ReadingDisplayContentBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ReadingDisplayContentBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // データの取得
        val fesId = intent.getStringExtra("objectId")
        val data = intent.getSerializableExtra("displayData")
        if (data is MarkerData){
            obj = data.data
        }
        val videoExist = obj["video"] as Boolean
        val tagStr = obj["tag"] as String
        val name = obj["name"] as String
        val placeStr = obj["place"] as String
        val managerStr = obj["manager"] as String
        val managerInfoStr = obj["managerInfo"] as String
        val infoStr = obj["info"] as String
        val dateStr = obj["date"] as String

        // 画像データの挿入
        val ref = Firebase.storage.reference.child(fesId!!).child("content-image").child("${name}.jpg")
        ref.downloadUrl.addOnSuccessListener { Uri ->
            val imgURL = Uri.toString()
            Glide.with(this@ReadingDisplayContent).load(imgURL).into(binding.rDisplayImageView)
        }

        // テキストデータの挿入
        binding.rDisplayContentTitle.text = name
        binding.tag.text = tagStr
        binding.place.text = placeStr
        binding.manager.text = managerStr
        binding.managerInfo.text = managerInfoStr
        binding.info.text = infoStr
        binding.date.text = dateStr

        // 動画を再生
        binding.playText.setOnClickListener {
            if (videoExist){
                val intent = Intent(this@ReadingDisplayContent ,PlayVideo::class.java)
                intent.putExtra("uuid", fesId)
                intent.putExtra("name",name)
                intent.putExtra("contentOrEvent", true)
                startActivity(intent)
            } else {
                val hud = CustomHUD(context = this@ReadingDisplayContent, text = "動画が投稿されていません")
                hud.dialog.show()
            }
        }
    }
}
