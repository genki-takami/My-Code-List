package jp.creative.primefunc.genki.takami.psynavi
/*
アプリケーションの設定
 */
import android.app.Application
import io.realm.Realm
import io.realm.RealmConfiguration

class MyApp: Application() {

    // 読み込み
    override fun onCreate() {
        super.onCreate()

        // Realmデータベースの初期化とスレッドの設定
        Realm.init(this)
        val realmConfig = RealmConfiguration.Builder()
            .deleteRealmIfMigrationNeeded()
            .allowWritesOnUiThread(true)
            .build()
        Realm.setDefaultConfiguration(realmConfig)
    }
}