package jp.seikei.judo.genki.takami.reportofsports_injuryapp
/*
アプリケーションの初期化
 */
import android.app.Application
import io.realm.Realm
import io.realm.RealmConfiguration

class MyApp: Application() {

    // 読み込み
    override fun onCreate() {
        super.onCreate()

        // データベースの初期化と設定
        Realm.init(this)
        val realmConfig = RealmConfiguration.Builder()
            .deleteRealmIfMigrationNeeded()
            .allowWritesOnUiThread(true)
            .build()
        Realm.setDefaultConfiguration(realmConfig)
    }
}