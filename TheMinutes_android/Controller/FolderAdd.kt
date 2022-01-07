package jp.seikei.judo.genki.takami.theminutesapp
/*
議事録フォルダを追加する処理
 */
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.google.android.material.snackbar.Snackbar
import io.realm.Realm
import jp.seikei.judo.genki.takami.theminutesapp.databinding.ActivityFolderAddBinding
import java.util.*

class FolderAdd : AppCompatActivity() {

    // 変数
    var mYear = Calendar.getInstance().get(Calendar.YEAR)
    var mMonth = Calendar.getInstance().get(Calendar.MONTH)
    var mDay = Calendar.getInstance().get(Calendar.DAY_OF_MONTH)
    var mHour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY)
    var mMinute = Calendar.getInstance().get(Calendar.MINUTE)
    lateinit var realm: Realm
    private lateinit var binding: ActivityFolderAddBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityFolderAddBinding.inflate(layoutInflater)
        setContentView(binding.root)

        title = "議事録フォルダの追加"

        // タップ：フォルダーを追加して戻る
        binding.doneButton.setOnClickListener{ view ->
            val folderName = binding.titleEditText.text.toString()
            if (folderName.isNotEmpty()){
                addFolder(folderName)
                finish()
            } else {
                Snackbar.make(view,"文字を入力してください！",Snackbar.LENGTH_LONG).show()
            }
        }
    }

    // フォルダーの追加
    private fun addFolder(text: String) {
        // データベースの設定
        realm = Realm.getDefaultInstance()

        realm.executeTransaction { r: Realm ->
            // インスタンスを作成し、id・フォルダー名・作成日時を代入
            val newFolder = FolderModel()
            val allResults = r.where(FolderModel::class.java).findAll()
            newFolder.id =
                if (allResults.max("id") != null) {
                    allResults.max("id")!!.toInt() + 1
                } else {
                    0
                }
            newFolder.groupName = text
            newFolder.date = GregorianCalendar(mYear, mMonth, mDay, mHour, mMinute).time
            // 保存
            r.insertOrUpdate(newFolder)
        }

        // シャットダウン
        realm.close()
    }
}