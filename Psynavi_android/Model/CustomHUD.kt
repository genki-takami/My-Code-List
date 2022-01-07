package jp.creative.primefunc.genki.takami.psynavi
/*
Head Up Display モジュール
 */
import android.content.Context
import androidx.appcompat.app.AlertDialog

class CustomHUD(context: Context, text: String) {
    // AlertDialogを使用してHUDを作成
    val dialog = AlertDialog.Builder(context)
        .setMessage(text)
        .setPositiveButton("閉じる", null)
        .create()
}