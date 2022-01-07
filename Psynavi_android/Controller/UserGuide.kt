package jp.creative.primefunc.genki.takami.psynavi
/*
使用ガイド画面の処理
 */
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import jp.creative.primefunc.genki.takami.psynavi.databinding.UserGuideBinding

class UserGuide : AppCompatActivity() {

    // レイアウトファイルと接合
    lateinit var binding: UserGuideBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = UserGuideBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // テキストの表示
        binding.userGuideText.text = """
            [１]
            　これまで紙のパンフレットや案内掲示板でまわっていた文化祭や地域の祭りをスマートフォン１つ、アプリ１つで楽むことができます！
            ※文化祭等の実行委員会が作成公開しているコンテンツのみ閲覧可能
            
            [２]
            　コメント機能を通じて文化祭での感想を送ることができます！思い出をシェアしよう！
            ※誰かを不快にさせるようなコメントは避けましょう
            
            [３]
            　地図を利用する際に、位置情報機能を「許可」すると現在地を把握しやすくなります！
            
            [４]
            　投票イベントに参加することでアプリをより楽しめます！ひとり１票でどのような結果になるか期待しましょう！
            ※コンテンツを公開しているユーザーが投票オプション(有料)を購入している場合のみ、投票イベントが表示されます。
            
            [５]
            　地図にて「案内マップ」ボタンをタップした際にお使いのGoogleアカウントを選択する場合がありますが、案内マップを閲覧するのにビューアを使用しますのでそのまま進んでください！
        """.trimIndent()
    }
}
