package jp.creative.primefunc.genki.takami.psynavi
/*
コメントネーム編集画面の処理
 */
import android.content.Context
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.inputmethod.InputMethodManager
import jp.creative.primefunc.genki.takami.psynavi.databinding.CommentNameEditBinding

class CommentNameEdit : AppCompatActivity() {

    // レイアウトファイルと接合
    lateinit var binding: CommentNameEditBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = CommentNameEditBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // 内部データベースからコメントネームを参照
        val sp = getSharedPreferences("userCommentName", Context.MODE_PRIVATE)
        val name = sp.getString("commentName","匿名")
        binding.currentCommentName.text = name

        // タップ：更新
        binding.btnUpdate.setOnClickListener { view ->
            val newName = binding.editorCommentName.text.toString()

            // キーボードを閉じる
            val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

            if (newName.isNotEmpty()){
                sp.edit().putString("commentName",newName).commit()
                binding.currentCommentName.text = newName
                binding.editorCommentName.setText("")
                val hud = CustomHUD(context = this@CommentNameEdit, text = "コメントネームを変更しました！")
                hud.dialog.show()
            } else {
                val hud = CustomHUD(context = this@CommentNameEdit, text = "文字を入力してください！")
                hud.dialog.show()
            }
        }
    }
}
