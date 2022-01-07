package jp.seikei.judo.genki.takami.theminutesapp
/*
議事録フォルダの処理
 */
import android.content.Context
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import io.realm.Realm
import jp.seikei.judo.genki.takami.theminutesapp.databinding.ActivityMainBinding
import io.realm.RealmChangeListener
import io.realm.Sort
import android.content.Intent
import androidx.appcompat.app.AlertDialog
import android.view.inputmethod.InputMethodManager
import android.widget.EditText
import com.google.android.material.snackbar.Snackbar
import io.realm.kotlin.where

class FolderList : AppCompatActivity() {

    // 変数
    lateinit var binding: ActivityMainBinding
    lateinit var fAdapter: FolderAdapter
    lateinit var realm: Realm

    // データベースのリスナー
    private val realmListener: RealmChangeListener<Realm> = RealmChangeListener {
        // リストの再読み込み
        reloadList()
    }

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        title = "議事録フォルダ"

        // タップ：フォルダー追加画面へ遷移
        binding.folderAddBtn.setOnClickListener { _ ->
            val intent = Intent(this@FolderList, FolderAdd::class.java)
            startActivity(intent)
        }

        // データベースの設定
        realm = Realm.getDefaultInstance()
        realm.addChangeListener(realmListener)

        // アダプターの設定
        fAdapter = FolderAdapter(this@FolderList)

        // タップ：議事録リストに遷移
        binding.folderList.setOnItemClickListener { parent, _, position, _ ->
            // 任意のレポートを取得してidとフォルダー名を渡す
            val folder = parent.adapter.getItem(position) as FolderModel
            val intent = Intent(this@FolderList, MinuteList::class.java)
            intent.putExtra(EXTRA_FOLDER, folder.id)
            intent.putExtra(EXTRA_MINUTE, folder.groupName)
            startActivity(intent)
        }

        // ロングタップ：フォルダー名の変更・フォルダーの削除
        binding.folderList.setOnItemLongClickListener { parent, view, position, _ ->
            // 任意のフォルダーを取得
            val folder = parent.adapter.getItem(position) as FolderModel

            // ダイアログの設定
            val builder = AlertDialog.Builder(this@FolderList)
            builder.setTitle("フォルダー名の変更と削除")
            builder.setMessage("フォルダー名を変更しますか？それとも「" + folder.groupName + "」を削除しますか？")
            val editObject = EditText(this)
            editObject.hint = "ここに入力してください"
            builder.setView(editObject)

            // フォルダー名を変更する
            builder.setPositiveButton("変更"){_, _ ->
                // キーボードを閉じる
                val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
                im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

                val newName = editObject.text.toString()
                if (newName.isNotEmpty()){
                    realm.executeTransaction { r: Realm ->
                        r.where(FolderModel::class.java).equalTo("id",folder.id).findFirst()?.let { data: FolderModel ->
                            data.groupName = newName
                            // 書き出す
                            r.insertOrUpdate(data)
                        }
                    }
                } else {
                    Snackbar.make(view, "文字を入力してください！", Snackbar.LENGTH_LONG).show()
                }
            }

            // 削除する
            builder.setNeutralButton("削除"){_, _ ->
                // すべての関連データをデータベースより参照
                realm.executeTransaction { r: Realm ->
                    val resultsMinute = r.where(MinuteModel::class.java).equalTo("parentGroupId",folder.id).findAll()
                    val resultsPlace = r.where(PlaceModel::class.java).equalTo("parentGroupId",folder.id).findAll()
                    val resultsMember = r.where(MemberModel::class.java).equalTo("parentGroupId",folder.id).findAll()
                    resultsMinute.deleteAllFromRealm()
                    resultsPlace.deleteAllFromRealm()
                    resultsMember.deleteAllFromRealm()
                    r.where(FolderModel::class.java).equalTo("id",folder.id).findFirst()?.let { data: FolderModel ->
                        data.deleteFromRealm()
                    }
                }
            }

            // キャンセル
            builder.setNegativeButton("CANCEL", null)

            // 削除ダイアログの表示
            val dialog = builder.create()
            dialog.show()

            true
        }
    }

    // 表示前処理
    override fun onStart() {
        super.onStart()

        // リストを読み込む
        reloadList()
    }

    // フォルダーリストの更新
    private fun reloadList() {
        // すべてのフォルダーデータを取得してソート
        val results = realm.where(FolderModel::class.java).findAll().sort("date", Sort.DESCENDING)

        // アダプターにデータをコピー、リストのアダプターに代入、アダプターにデータが変更されたことを知らせる
        fAdapter.folderList = realm.copyFromRealm(results)
        binding.folderList.adapter = fAdapter
        fAdapter.notifyDataSetChanged()
    }

    // シャットダウン処理
    override fun onDestroy() {
        super.onDestroy()

        // データベースのシャットダウン
        realm.close()
    }
}