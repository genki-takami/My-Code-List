package jp.seikei.judo.genki.takami.theminutesapp
/*
出席者登録画面の処理
 */
import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import jp.seikei.judo.genki.takami.theminutesapp.databinding.ActivityMemberAddBinding
import io.realm.Realm
import io.realm.RealmChangeListener
import androidx.appcompat.app.AlertDialog
import android.view.inputmethod.InputMethodManager
import com.google.android.material.snackbar.Snackbar

class MemberAdd : AppCompatActivity() {

    // 変数
    lateinit var mAdapter: MemberAdapter
    lateinit var realm: Realm
    lateinit var binding: ActivityMemberAddBinding
    var folderId:Int = 0

    // データベースのリスナー
    private val realmListener: RealmChangeListener<Realm> = RealmChangeListener {
        // リストの再読み込み
        reloadList()
    }

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMemberAddBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // フォルダーidとフォルダー名を取得する
        folderId = intent.getIntExtra(EXTRA_FOLDER, -1)
        val fn = intent.getStringExtra(EXTRA_MINUTE)

        // データベースの設定
        realm = Realm.getDefaultInstance()
        realm.addChangeListener(realmListener)

        // アダプターの設定
        mAdapter = MemberAdapter(this@MemberAdd)

        // タップ：出席者を登録する
        binding.memberAddBtn.setOnClickListener{ view ->
            // キーボードを閉じる
            val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

            addMember(view)
            binding.registerMemberEditText.setText("")
        }

        // 前画面に戻る
        binding.backBtn.setOnClickListener{ _ ->
            val intent = Intent(this@MemberAdd, Setting::class.java)
            intent.putExtra(EXTRA_FOLDER, folderId)
            intent.putExtra(EXTRA_MINUTE, fn)
            startActivity(intent)
        }

        // ロングタップ：データを削除する
        binding.memberList.setOnItemLongClickListener { parent, _, position, _ ->

            // 任意の出席者を取得
            val member = parent.adapter.getItem(position) as MemberModel

            // ダイアログを設定する
            val builder = AlertDialog.Builder(this@MemberAdd)
            builder.setTitle("削除")
            builder.setMessage(member.memberName + "を削除しますか")

            // 削除する
            builder.setPositiveButton("はい"){_, _ ->
                realm.executeTransaction { r: Realm ->
                    r.where(MemberModel::class.java).equalTo("id",member.id).findFirst()?.let { data: MemberModel ->
                        data.deleteFromRealm()
                    }
                }
            }

            // 削除しない
            builder.setNegativeButton("いいえ", null)

            // ダイアログの表示
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

    // 出席者を追加
    private fun addMember(view: View){

        realm.executeTransaction { r: Realm ->

            val member = MemberModel()
            val results = realm.where(MemberModel::class.java).findAll()

            // idを付与
            member.id =
                if (results.max("id") != null) {
                    results.max("id")!!.toInt() + 1
                } else {
                    0
                }

            // 名前とフォルダーidを挿入
            val str = binding.registerMemberEditText.text.toString()
            if (str.isNotEmpty()){
                member.memberName = str
                member.parentGroupId = folderId
                r.insertOrUpdate(member)
            } else {
                Snackbar.make(view, "文字を入力してください！",Snackbar.LENGTH_LONG).show()
            }
        }
    }

    // リストの更新
    private fun reloadList() {
        // データベースから取得
        val results = realm.where(MemberModel::class.java).equalTo("parentGroupId",folderId).findAll()

        // アダプターにデータをコピー、リストのアダプターに代入、アダプターにデータが変更されたことを知らせる
        mAdapter.memberList = realm.copyFromRealm(results)
        binding.memberList.adapter = mAdapter
        mAdapter.notifyDataSetChanged()
    }

    // シャットダウン処理
    override fun onDestroy() {
        super.onDestroy()

        // データベースのシャットダウン
        realm.close()
    }
}
