package jp.seikei.judo.genki.takami.theminutesapp
/*
議事録リストの処理
 */
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import io.realm.Realm
import jp.seikei.judo.genki.takami.theminutesapp.databinding.ActivityMinuteListBinding
import io.realm.RealmChangeListener
import io.realm.Sort
import android.content.Intent
import androidx.appcompat.app.AlertDialog

class MinuteList : AppCompatActivity() {

    // 変数
    lateinit var mAdapter: MinuteAdapter
    var folderId:Int = 0
    lateinit var realm: Realm
    lateinit var binding: ActivityMinuteListBinding

    // データベースのリスナー
    private val realmListener: RealmChangeListener<Realm> = RealmChangeListener {
        // リストの再読み込み
        reloadList()
    }

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMinuteListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // フォルダー名を受け取り、タイトルにする
        val fn = intent.getStringExtra(EXTRA_MINUTE)
        title = fn

        // フォルダーidを受け取る
        folderId = intent.getIntExtra(EXTRA_FOLDER, -1)

        // タップ：議事録の追加画面へ遷移
        binding.minuteAddBtn.setOnClickListener { _ ->
            val intent = Intent(this@MinuteList, MinuteAdd::class.java)
            intent.putExtra(EXTRA_FOLDER, folderId)
            startActivity(intent)
        }

        // タップ：フォルダー画面に戻る
        binding.backFolderListBtn.setOnClickListener { _ ->
            val intent = Intent(this@MinuteList, FolderList::class.java)
            startActivity(intent)
        }

        // タップ：設定画面に遷移
        binding.goSettingBtn.setOnClickListener { _ ->
            val intent = Intent(this@MinuteList, Setting::class.java)
            intent.putExtra(EXTRA_FOLDER, folderId)
            intent.putExtra(EXTRA_MINUTE, fn)
            startActivity(intent)
        }

        // データベースの設定
        realm = Realm.getDefaultInstance()
        realm.addChangeListener(realmListener)

        // アダプターの設定
        mAdapter = MinuteAdapter(this@MinuteList)

        // タップ：議事録の編集画面へ遷移
        binding.minuteList.setOnItemClickListener { parent, _, position, _ ->
            val minute = parent.adapter.getItem(position) as MinuteModel
            val intent = Intent(this@MinuteList, MinuteAdd::class.java)
            intent.putExtra(EXTRA_MINUTE, minute.id) // 議事録ID
            intent.putExtra(EXTRA_FOLDER, folderId)  // フォルダーID
            startActivity(intent)
        }

        // ロングタップ：議事録を削除
        binding.minuteList.setOnItemLongClickListener { parent, _, position, _ ->
            // 任意の議事録を取得
            val minute = parent.adapter.getItem(position) as MinuteModel

            // 削除ダイアログの設定
            val builder = AlertDialog.Builder(this@MinuteList)
            builder.setTitle("削除")
            builder.setMessage(minute.meetingName + "を削除しますか")

            // 削除する
            builder.setPositiveButton("はい"){_, _ ->
                realm.executeTransaction { r: Realm ->
                    r.where(MinuteModel::class.java).equalTo("id",minute.id).findFirst()?.let { data: MinuteModel ->
                        data.deleteFromRealm()
                    }
                }
            }

            // 削除しない
            builder.setNegativeButton("いいえ", null)

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

    // 議事録リストの更新
    private fun reloadList() {
        // すべての議事録データを取得
        val results = realm.where(MinuteModel::class.java).equalTo("parentGroupId", folderId).findAll().sort("dateAndTime", Sort.DESCENDING)

        // アダプターにデータをコピー、リストのアダプターに代入、アダプターにデータが変更されたことを知らせる
        mAdapter.minuteList = realm.copyFromRealm(results)
        binding.minuteList.adapter = mAdapter
        mAdapter.notifyDataSetChanged()
    }

    // シャットダウン処理
    override fun onDestroy() {
        super.onDestroy()

        // データベースのシャットダウン
        realm.close()
    }
}