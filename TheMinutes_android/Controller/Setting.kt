package jp.seikei.judo.genki.takami.theminutesapp
/*
設定画面の処理
 */
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import jp.seikei.judo.genki.takami.theminutesapp.databinding.ActivitySettingBinding

class Setting : AppCompatActivity() {

    // 変数
    lateinit var binding: ActivitySettingBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySettingBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // フォルダーidとフォルダー名を取得する
        val folderId = intent.getIntExtra(EXTRA_FOLDER, -1)
        val fn = intent.getStringExtra(EXTRA_MINUTE)

        title = fn!! + "の登録設定"

        // タップ：会議場所登録画面へ遷移
        binding.toPlaceButton.setOnClickListener{ _ ->
            val intent = Intent(this@Setting, PlaceAdd::class.java)
            intent.putExtra(EXTRA_FOLDER, folderId)
            intent.putExtra(EXTRA_MINUTE, fn)
            startActivity(intent)
        }

        // タップ：出席者登録画面へ遷移
        binding.toMemberButton.setOnClickListener{ _ ->
            val intent = Intent(this@Setting, MemberAdd::class.java)
            intent.putExtra(EXTRA_FOLDER, folderId)
            intent.putExtra(EXTRA_MINUTE, fn)
            startActivity(intent)
        }

        // タップ：議事録リスト画面へ戻る
        binding.toMinuteListButton.setOnClickListener{ _ ->
            val intent = Intent(this@Setting, MinuteList::class.java)
            intent.putExtra(EXTRA_FOLDER, folderId)
            intent.putExtra(EXTRA_MINUTE, fn)
            startActivity(intent)
        }
    }
}
