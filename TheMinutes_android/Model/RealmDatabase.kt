package jp.seikei.judo.genki.takami.theminutesapp
/*
アプリケーションの初期化
 */
import android.app.Application
import io.realm.Realm
import io.realm.RealmConfiguration

class RealmDatabase: Application() {
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