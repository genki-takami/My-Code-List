package jp.creative.primefunc.genki.takami.psynavi
/*
お気に入りタブの処理
 */
import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import io.realm.Realm
import io.realm.RealmResults
import jp.creative.primefunc.genki.takami.psynavi.databinding.FavoriteBinding

class Favorite : Fragment() {

    // 変数
    lateinit var adapter: FavoriteAdapter
    lateinit var realm: Realm
    lateinit var dataSets: ArrayList<FavoriteModel>
    lateinit var results: RealmResults<FavoriteModel>
    private var _binding: FavoriteBinding? = null
    val binding get() = _binding!!

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // データベースの設定
        realm = Realm.getDefaultInstance()
    }

    // レイアウトの設定
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        _binding = FavoriteBinding.inflate(inflater, container, false)
        return binding.root
    }

    // レイアウトの作成
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {

        // アダプターの設定
        adapter = FavoriteAdapter(view.context)

        // お気に入りがあれば挿入する
        results = realm.where(FavoriteModel::class.java).findAll()
        if (results.isNotEmpty()){
            dataSets = ArrayList()
            for (i in results){
                dataSets.add(i)
            }
            adapter.dataList = dataSets
        }

        // アダプターの設定
        binding.FavoriteList.adapter = adapter
        adapter.notifyDataSetChanged()

        super.onViewCreated(view, savedInstanceState)
    }

    // フラグメントの破棄
    override fun onDestroyView() {
        // ローカルデータベースのシャットダウン
        this.realm.close()
        adapter.realm.close()

        super.onDestroyView()
        _binding = null
    }
}