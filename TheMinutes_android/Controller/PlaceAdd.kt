package jp.seikei.judo.genki.takami.theminutesapp
/*
会議場所登録画面の処理
 */
import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.View
import jp.seikei.judo.genki.takami.theminutesapp.databinding.ActivityPlaceAddBinding
import io.realm.Realm
import io.realm.RealmChangeListener
import androidx.appcompat.app.AlertDialog
import android.view.inputmethod.InputMethodManager
import com.google.android.material.snackbar.Snackbar

class PlaceAdd : AppCompatActivity() {

    // 変数
    lateinit var pAdapter: PlaceAdapter
    lateinit var realm: Realm
    var folderId:Int = 0
    lateinit var binding: ActivityPlaceAddBinding

    // データベースのリスナー
    private val realmListener: RealmChangeListener<Realm> = RealmChangeListener {
        // リストの再読み込み
        reloadList()
    }

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityPlaceAddBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // フォルダーidとフォルダー名を取得する
        folderId = intent.getIntExtra(EXTRA_FOLDER, -1)
        val fn = intent.getStringExtra(EXTRA_MINUTE)

        // データベースの設定
        realm = Realm.getDefaultInstance()
        realm.addChangeListener(realmListener)

        // アダプターの設定
        pAdapter = PlaceAdapter(this@PlaceAdd)

        // タップ：会議場所を登録する
        binding.placeAddBtn.setOnClickListener{ view ->
            // キーボードを閉じる
            val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

            addPlace(view)
            binding.registerPlaceEditText.setText("")
        }

        // タップ：前画面に戻る
        binding.backBtn.setOnClickListener{ _ ->
            val intent = Intent(this@PlaceAdd, Setting::class.java)
            intent.putExtra(EXTRA_FOLDER, folderId)
            intent.putExtra(EXTRA_MINUTE, fn)
            startActivity(intent)
        }

        // ロングタップ：データを削除する
        binding.placeList.setOnItemLongClickListener { parent, _, position, _ ->

            // 任意の会議場所を取得
            val place = parent.adapter.getItem(position) as PlaceModel

            // ダイアログの設定
            val builder = AlertDialog.Builder(this@PlaceAdd)
            builder.setTitle("削除")
            builder.setMessage(place.placeName + "を削除しますか")

            // 削除する
            builder.setPositiveButton("はい"){_, _ ->
                realm.executeTransaction { r: Realm ->
                    r.where(PlaceModel::class.java).equalTo("id",place.id).findFirst()?.let { data: PlaceModel ->
                        data.deleteFromRealm()
                    }
                }
            }

            // 削除しない
            builder.setNegativeButton("いいえ", null)

            // ダイアログを表示
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

    // 会議場所を追加する
    private fun addPlace(view: View){

        realm.executeTransaction { r: Realm ->
            val place = PlaceModel()

            val results = realm.where(PlaceModel::class.java).findAll()
            // idを付与
            place.id =
                if (results.max("id") != null) {
                    results.max("id")!!.toInt() + 1
                } else {
                    0
                }

            // 名前とフォルダーidを挿入
            val str = binding.registerPlaceEditText.text.toString()
            if (str.isNotEmpty()){
                place.placeName = str
                place.parentGroupId = folderId
                r.insertOrUpdate(place)
            } else {
                Snackbar.make(view, "文字を入力してください！", Snackbar.LENGTH_LONG).show()
            }
        }
    }

    // リストの更新
    private fun reloadList() {
        // データベースから取得
        val results = realm.where(PlaceModel::class.java).equalTo("parentGroupId",folderId).findAll()

        // アダプターにデータをコピー、リストのアダプターに代入、アダプターにデータが変更されたことを知らせる
        pAdapter.placeList = realm.copyFromRealm(results)
        binding.placeList.adapter = pAdapter
        pAdapter.notifyDataSetChanged()
    }

    // シャットダウン処理
    override fun onDestroy() {
        super.onDestroy()

        // データベースのシャットダウン
        realm.close()
    }
}
