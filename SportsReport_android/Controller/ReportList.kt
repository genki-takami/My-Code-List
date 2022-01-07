package jp.seikei.judo.genki.takami.reportofsports_injuryapp
/*
外傷レポートリスト画面の処理
 */
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import android.content.Intent
import androidx.appcompat.app.AlertDialog
import io.realm.Realm
import io.realm.RealmChangeListener
import io.realm.Sort
import jp.seikei.judo.genki.takami.reportofsports_injuryapp.databinding.ActivityMainBinding

class ReportList : AppCompatActivity() {

    // 変数
    lateinit var binding: ActivityMainBinding
    lateinit var rAdapter: ReportAdapter
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

        title = "外傷レポートリスト"

        // データベースの設定
        realm = Realm.getDefaultInstance()
        realm.addChangeListener(realmListener)

        // アダプターの設定
        rAdapter = ReportAdapter(this@ReportList)

        // タップ：レポートの追加
        binding.reportAddBtn.setOnClickListener { _ ->
            val intent = Intent(applicationContext, ReportAdd::class.java)
            startActivity(intent)
        }

        // タップ：プレビュー画面へ遷移
        binding.reportList.setOnItemClickListener { parent, _, position, _ ->
            // 任意のレポートを取得してidを渡す
            val report = parent.adapter.getItem(position) as ReportModel
            val intent = Intent(applicationContext, PreviewAndShare::class.java)
            intent.putExtra("reportData", report.id)
            startActivity(intent)
        }

        // ロングタップ：レポートの削除・編集画面へ遷移
        binding.reportList.setOnItemLongClickListener { parent, _, position, _ ->

            // 任意のレポートを取得
            val report = parent.adapter.getItem(position) as ReportModel

            // ダイアログの構築と設定
            val builder = AlertDialog.Builder(this@ReportList)
            builder.setTitle("レポートの編集と削除")
            builder.setMessage("レポートを変更しますか？それとも削除しますか？")

            // 編集する
            builder.setPositiveButton("編集"){_, _ ->
                val intent = Intent(applicationContext, ReportAdd::class.java)
                intent.putExtra("reportData", report.id)
                startActivity(intent)
            }

            // 削除
            builder.setNeutralButton("削除"){_, _ ->
                realm.executeTransaction{
                    realm.where(ReportModel::class.java).equalTo("id", report.id).findFirst()?.let { data: ReportModel ->
                        data.deleteFromRealm()
                    }
                }
            }

            // キャンセル
            builder.setNegativeButton("CANCEL", null)

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

    // フォルダーリストの更新
    private fun reloadList() {
        // すべてのレポートデータを取得してソート
        val results = realm.where(ReportModel::class.java).findAll().sort("id", Sort.DESCENDING)

        // アダプターにデータをコピー、リストのアダプターに代入、アダプターにデータが変更されたことを知らせる
        rAdapter.reportList = realm.copyFromRealm(results)
        binding.reportList.adapter = rAdapter
        rAdapter.notifyDataSetChanged()
    }

    // シャットダウン処理
    override fun onDestroy() {
        super.onDestroy()

        // データベースのシャットダウン
        realm.close()
    }
}
