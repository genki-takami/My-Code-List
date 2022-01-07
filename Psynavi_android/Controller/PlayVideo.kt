package jp.creative.primefunc.genki.takami.psynavi
/*
動画を視聴するクラス
 */
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.widget.MediaController
import androidx.appcompat.app.AppCompatActivity
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.StorageReference
import com.google.firebase.storage.ktx.storage
import jp.creative.primefunc.genki.takami.psynavi.databinding.PlayVideoBinding

class PlayVideo : AppCompatActivity() {

    // 変数
    lateinit var binding: PlayVideoBinding
    lateinit var ref: StorageReference
    private var contentOrEvent = true

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = PlayVideoBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // データを受け取る
        val fesID = intent.getStringExtra("uuid")
        val name = intent.getStringExtra("name")
        contentOrEvent = intent.getBooleanExtra("contentOrEvent", true)

        // 動画処理
        Handler(Looper.getMainLooper()).postDelayed({
            // 動画を準備
            val fileName = name!! + ".mp4"
            ref = if (contentOrEvent){
                // ショップ/展示
                Firebase.storage.reference.child(fesID!!).child("content-video").child(fileName)
            } else {
                // イベント
                Firebase.storage.reference.child(fesID!!).child("event-video").child(fileName)
            }
            ref.downloadUrl.addOnSuccessListener { Uri ->
                val path = android.net.Uri.parse(Uri.toString())
                binding.videoView.setVideoURI(path)
                // 再生開始リスナー
                binding.videoView.setOnPreparedListener {
                    binding.videoView.start()
                    // 再生メニューの表示
                    binding.videoView.setMediaController(MediaController(this))
                }
            }
                .addOnFailureListener { finish() }
        },200)
    }
}
