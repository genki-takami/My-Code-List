package jp.creative.primefunc.genki.takami.psynavi
/*
運営画面の処理
 */
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import jp.creative.primefunc.genki.takami.psynavi.databinding.ManagerInfoBinding

class ManagerInfo : AppCompatActivity() {

    // レイアウトファイルと接合
    lateinit var binding: ManagerInfoBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ManagerInfoBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // テキストの表示
        binding.textProf.text = """
            たかみげんき
            プログラマ兼大学生
            
            文化祭のパンフレットをスマホに移植できないかなぁーと思いこのアプリを作りました！
        """.trimIndent()

        // リリースノート
        binding.textVersionInfo.text = """
            ＜Psyなびのリリースノート＞
            ・バージョン1.0　アプリリリース
            ・バージョン2.0　地図が表示されないバグを修正
            ・バージョン3.0　アプリが縦画面で固定されるように修正
            ・バージョン4.0　バグの修正およびパフォーマンスの向上
            ・バージョン5.0　投票機能の追加
            ・バージョン6.0　バグの修正およびパフォーマンスの向上
            ・バージョン7.0　動画視聴機能の追加
            ・バージョン8.0　地図にて案内マップの追加
            ・バージョン9.0　開発者からのお知らせがたまに来ます
        """.trimIndent()
    }
}
