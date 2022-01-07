package jp.creative.primefunc.genki.takami.psynavi
/*
お問い合わせ画面の処理
 */
import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.inputmethod.InputMethodManager
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import jp.creative.primefunc.genki.takami.psynavi.databinding.ContactFormBinding

class ContactForm : AppCompatActivity() {

    // レイアウトファイルと接合
    lateinit var binding: ContactFormBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ContactFormBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // タップ：送信
        binding.btnSend.setOnClickListener { view ->
            val title = binding.editorTitle.text.toString()
            val content = binding.editorContent.text.toString()

            // キーボードを閉じる
            val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

            if (title.isNotEmpty() && content.isNotEmpty()){
                // データを形成
                val data = hashMapOf(
                    "title" to title,
                    "content" to content
                )
                // Firestoreに送信
                Firebase.firestore.collection("inquiry")
                    .add(data)
                    .addOnSuccessListener {
                        val hud = CustomHUD(context = this@ContactForm, text = "送信成功！")
                        hud.dialog.show()
                    }
                    .addOnFailureListener{
                        val hud = CustomHUD(context = this@ContactForm, text = "送信失敗！再度送信してください！")
                        hud.dialog.show()
                    }
            } else {
                val hud = CustomHUD(context = this@ContactForm, text = "文字を入力してください！")
                hud.dialog.show()
            }
        }

        // 注意テキストの表示
        binding.textNotification.text = """
            ＜おねがい＞
            　お問い合わせ内容に関してはアプリのアップデートにて改善されるよう努力します。個別での対応はできません
        """.trimIndent()
    }
}
