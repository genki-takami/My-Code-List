package jp.creative.primefunc.genki.takami.psynavi
/*
プライバシーポリシー画面の処理
 */
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import jp.creative.primefunc.genki.takami.psynavi.databinding.PrivacyPolicyBinding

class PrivacyPolicy : AppCompatActivity() {

    // レイアウトファイルと接合
    lateinit var binding: PrivacyPolicyBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = PrivacyPolicyBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // テキストの表示
        binding.privacyPolicyText.text = """
            [利用者情報の取得]

            　本アプリを使用することを選択した場合、あなたはこのポリシーに関連する情報の取得に同意するものとします。
            
            　開発者が収集した個人情報は、本アプリサービスの提供および改善に使用されます。このプライバシーポリシーに記載されている場合を除き、開発者はあなたの情報を使用したり、他人と共有したりしません。
            
            　より良い体験のために、本アプリを使用している間、特定の個人情報を提供するように要求する場合があります。本アプリが要求する情報はあなたのデバイスに保持され、開発者が収集することはありません。
            
            　サービス利用時に本アプリでエラーやクラッシュが発生した場合、サードパーティ製品を通じてログデータを収集することがあります。このログデータには、デバイスのインターネットプロトコル(IP)アドレス、デバイス名、オペレーティングシステムのバージョン、 本アプリを利用する際のアプリの構成、本アプリの使用日時、その他の統計情報が含まれる場合があります。
            
            　Cookieは、匿名の一意の識別子として一般的に使用される少量のデータを含むファイルです。 これらは、アクセスしたWebサイトからブラウザに送信され、デバイスの内部メモリに保存されます。
            
            　本アプリは、これらの「Cookie」を明示的に使用しません。 ただし、本アプリは「Cookie」を使用して情報を収集し、サービスを改善するサードパーティのコードとライブラリを使用する場合があります。
            
            [利用者情報の第三者提供]
            
            　本アプリは、あなたを識別するために使用される情報を収集する可能性のあるサードパーティのサービスを使用します。
            
            　本アプリが使用するサードパーティのサービスプロバイダーのプライバシーポリシーへのリンクは以下になります。
            　https://firebase.google.com/policies/analytics
            
            主な利用目的は以下になります
            (1)開発者に代わって一部サービスを提供するため
            (2)本アプリ関連のサービスを実行するため
            (3)本アプリサービスがどのように使用されているかを分析するのを支援するため
            
            [他のサイトへのリンク]
            
            　本アプリには、他のサイトへのリンクが含まれている場合があります。リンクをクリックすると、そのサイトに移動します。これらの外部サイトは開発者が運営していないことに注意してください。したがって、それらのWebサイトのプライバシーポリシーを確認することを強くお勧めします。
            
            　開発者は、第三者のサイトまたはサービスのコンテンツ、プライバシーポリシー、または慣行を管理することはできず、責任を負わないものとします。
            
            [子供のプライバシー]
            
            　本アプリは13歳未満の子供から個人を特定できる情報を故意に収集することはありません。
            
            [お問い合わせ先]
            
            何かご不明な点がございましたら
            takamigenkiseikei@gmail.com
            にお問い合わせください。
        """.trimIndent()
    }
}
