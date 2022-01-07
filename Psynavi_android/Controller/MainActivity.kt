package jp.creative.primefunc.genki.takami.psynavi
/*
ナビゲーションタブの処理
 */
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.google.android.material.bottomnavigation.BottomNavigationView
import jp.creative.primefunc.genki.takami.psynavi.databinding.ActivityMainBinding

class MainActivity : AppCompatActivity() {

    // レイアウトファイルと接合
    lateinit var binding: ActivityMainBinding

    // フラグメントの切り替えとタブ選択のリスナー
    val onis = BottomNavigationView.OnNavigationItemSelectedListener { item ->
        when (item.itemId) {
            R.id.navigation_home -> {
                supportFragmentManager.beginTransaction()
                    .replace(R.id.frameLayout,Home())
                    .commit()
                return@OnNavigationItemSelectedListener true
            }
            R.id.favorite -> {
                supportFragmentManager.beginTransaction()
                    .replace(R.id.frameLayout,Favorite())
                    .commit()
                return@OnNavigationItemSelectedListener true
            }
            R.id.notice -> {
                supportFragmentManager.beginTransaction()
                    .replace(R.id.frameLayout,Notice())
                    .commit()
                return@OnNavigationItemSelectedListener true
            }
            R.id.setting -> {
                supportFragmentManager.beginTransaction()
                    .replace(R.id.frameLayout,Setting())
                    .commit()
                return@OnNavigationItemSelectedListener true
            }
        }
        false
    }

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // リスナーを設定
        binding.navigation.setOnNavigationItemSelectedListener(onis)

        // 初期値を設定
        supportFragmentManager.beginTransaction()
            .replace(R.id.frameLayout,Home())
            .commit()
    }
}