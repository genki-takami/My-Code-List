package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツのイベントグリッド画像の拡大画面の処理
 */
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Base64
import jp.creative.primefunc.genki.takami.psynavi.databinding.ReadingEventShowImageBinding

class ReadingEventShowImage : AppCompatActivity() {

    // レイアウトファイルと接合
    lateinit var binding: ReadingEventShowImageBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ReadingEventShowImageBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // データを取得
        val image = intent.getStringExtra("image")
        val caption = intent.getStringExtra("caption")

        // データを挿入
        binding.bigImageText.text = caption!!.drop(10)
        if (image!!.isNotEmpty()){
            val bytes = Base64.decode(image, Base64.DEFAULT)
            val img = BitmapFactory.decodeByteArray(bytes, 0, bytes.size).copy(Bitmap.Config.ARGB_8888, true)
            binding.bigImageView.setImageBitmap(img)
        }
    }
}
