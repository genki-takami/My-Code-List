package jp.seikei.judo.genki.takami.reportofsports_injuryapp
/*
プレビュー画面の処理
 */
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.util.Base64
import io.realm.Realm
import jp.seikei.judo.genki.takami.reportofsports_injuryapp.databinding.ActivityPreviewAndShareBinding
import java.text.SimpleDateFormat
import java.util.*

class PreviewAndShare : AppCompatActivity() {

    // 変数
    lateinit var realm: Realm
    private lateinit var binding: ActivityPreviewAndShareBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityPreviewAndShareBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // レポートidを受け取る
        val reportId = intent.getIntExtra("reportData", -1)

        // データベースの設定
        realm = Realm.getDefaultInstance()

        // タップ：共有する
        binding.share.setOnClickListener { _ ->
            share()
        }

        realm.where(ReportModel::class.java).equalTo("id", reportId).findFirst()?.let {
            val t1 = "【負傷者】\n" + "　" + it.person
            binding.preinjuredPersonName.text = t1
            val t2 = "【報告者】\n" + "　" + it.reporter
            binding.prereporterName.text = t2
            val t3 = "【日時】\n" + "　" + SimpleDateFormat("yyyy/MM/dd HH:mm", Locale.JAPANESE).format(it.dateAndTime)
            binding.predateAndTimes.text = t3
            val t4 = "【場所】\n" + "　" + it.place
            binding.preinjuredPlace.text = t4
            val t5 = "【部位】\n" + "　" + it.position
            binding.preinjuredPosition.text = t5
            val t6 = "【医師からの診断名】\n" + "　" + it.diagnosis
            binding.prediagnosis.text = t6
            val t7 = "【原因】\n" + "　" + it.cause
            binding.precause.text = t7
            val t8 = "【後遺症など】\n" + "　" + it.afterEffect
            binding.preafterEffect.text = t8

            if (it.picture.isNotEmpty()) {
                val bytes = Base64.decode(it.picture, Base64.DEFAULT)
                val image = BitmapFactory.decodeByteArray(bytes, 0, bytes.size).copy(Bitmap.Config.ARGB_8888, true)
                binding.preimageView.setImageBitmap(image)
            }
        }
    }

    // 共有intentの表示
    private fun share(){
        val intentReport1 = binding.preinjuredPersonName.text.toString() + "\n" + binding.prereporterName.text.toString() + "\n" + binding.predateAndTimes.text.toString()
        val intentReport2 = binding.preinjuredPlace.text.toString() + "\n" + binding.preinjuredPosition.text.toString() + "\n" + binding.prediagnosis.text.toString()
        val intentReport3 = binding.precause.text.toString() + "\n" + binding.preafterEffect.text.toString()
        val intentReport = intentReport1  + "\n" + intentReport2 + "\n" + intentReport3
        val sendIntent: Intent = Intent().apply {
            action = Intent.ACTION_SEND
            putExtra(Intent.EXTRA_TEXT, intentReport)
            type = "text/plain"
        }

        val shareIntent = Intent.createChooser(sendIntent, null)
        startActivity(shareIntent)
    }

    // シャットダウン処理
    override fun onDestroy() {
        super.onDestroy()

        // データベースのシャットダウン
        realm.close()
    }
}
