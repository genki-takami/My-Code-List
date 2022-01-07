package jp.seikei.judo.genki.takami.reportofsports_injuryapp
/*
タイムゾーンの受信
 */
import android.content.BroadcastReceiver
import android.content.Context
import android.widget.Toast
import android.content.Intent

class TimezoneBroadcastReceiver: BroadcastReceiver() {

    // 受信
    override fun onReceive(context: Context, intent: Intent) {
        Toast.makeText(context, "タイムゾーンが変化しました", Toast.LENGTH_LONG).show()
    }
}