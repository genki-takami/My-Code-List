package jp.creative.primefunc.genki.takami.psynavi
/*
パーミッションリクエスト関連のオブジェクト
 */
import android.Manifest
import android.app.AlertDialog
import android.app.Dialog
import android.content.DialogInterface
import android.content.pm.PackageManager
import android.os.Bundle
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import androidx.core.app.ActivityCompat
import androidx.fragment.app.DialogFragment

object PermissionUtils {

    @JvmStatic
    fun requestPermission(activity: AppCompatActivity, requestId: Int, permission: String, finishActivity: Boolean) {
        if (ActivityCompat.shouldShowRequestPermissionRationale(activity, permission)) {
            // 許可されている
            RationaleDialog.newInstance(requestId, finishActivity).show(activity.supportFragmentManager, "dialog")
        } else {
            // 許可されていない
            ActivityCompat.requestPermissions(activity, arrayOf(permission), requestId)
        }
    }

    @JvmStatic
    fun isPermissionGranted(grantPermissions: Array<String>, grantResults: IntArray, permission: String): Boolean {
        for (i in grantPermissions.indices) {
            // 許可を判別
            if (permission == grantPermissions[i]) {
                // 許可の最終判定
                return grantResults[i] == PackageManager.PERMISSION_GRANTED
            }
        }
        // 許可されない
        return false
    }

    // ダイアログのオブジェクトクラス
    class RationaleDialog : DialogFragment() {

        // 変数
        private var finishActivity = false

        // ダイアログを作成
        override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
            val requestCode = arguments?.getInt(ARGUMENT_PERMISSION_REQUEST_CODE) ?: 0
            finishActivity = arguments?.getBoolean(ARGUMENT_FINISH_ACTIVITY) ?: false

            return AlertDialog.Builder(activity)
                .setMessage("【インフォメーション】\n位置情報をオンにすると地図上での現在地が把握しやすくなります。\n【ヘルプ】\n現在地が表示されない場合、許可した上で前画面に戻ってから再度地図を開いてください。")
                .setPositiveButton("次へ") { _, _ ->
                    // 許可を求める
                    ActivityCompat.requestPermissions(activity!!, arrayOf(Manifest.permission.ACCESS_FINE_LOCATION), requestCode)

                    finishActivity = false
                }
                .setNegativeButton("地図を終了", null)
                .create()
        }

        // 地図画面を終了する
        override fun onDismiss(dialog: DialogInterface) {
            super.onDismiss(dialog)

            // 終了
            if (finishActivity) {
                Toast.makeText(activity, "地図を終了しました", Toast.LENGTH_LONG).show()
                activity?.finish()
            }
        }

        // 共有オブジェクト
        companion object {

            // 変数
            private const val ARGUMENT_PERMISSION_REQUEST_CODE = "requestCode"
            private const val ARGUMENT_FINISH_ACTIVITY = "finish"

            fun newInstance(requestCode: Int, finishActivity: Boolean): RationaleDialog {
                // 引数を設定
                val arguments = Bundle().apply {
                    putInt(ARGUMENT_PERMISSION_REQUEST_CODE, requestCode)
                    putBoolean(ARGUMENT_FINISH_ACTIVITY, finishActivity)
                }
                // 引数を代入してダイアログを表示
                return RationaleDialog().apply {
                    this.arguments = arguments
                }
            }
        }
    }
}