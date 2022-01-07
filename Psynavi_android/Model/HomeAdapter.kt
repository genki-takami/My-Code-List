package jp.creative.primefunc.genki.takami.psynavi
/*
ホームタブのリストのアダプター
 */
import android.content.Context
import android.content.Intent
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.*
import com.google.firebase.firestore.QueryDocumentSnapshot
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.StorageReference
import com.google.firebase.storage.ktx.storage
import com.bumptech.glide.Glide
import io.realm.Realm

class HomeAdapter(context: Context) : BaseAdapter(){

    // 変数
    var inflater: LayoutInflater
    var storage: StorageReference
    var docList = mutableListOf<QueryDocumentSnapshot>()
    var realm: Realm

    // 初期化処理
    init {
        this.inflater = LayoutInflater.from(context)
        this.storage = Firebase.storage.reference
        this.realm = Realm.getDefaultInstance()
    }

    // リストの数を返す
    override fun getCount(): Int {
        return docList.size
    }

    // リストのデータを返す
    override fun getItem(position: Int): QueryDocumentSnapshot {
        return docList[position]
    }

    // リストのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // リストの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        val view: View = convertView ?: inflater.inflate(R.layout.home_list, parent, false)

        // ドキュメントのID
        val docId = getItem(position).id

        // オブジェクトを取得
        val festivalName = view.findViewById<TextView>(R.id.festivalName)
        val date = view.findViewById<TextView>(R.id.date)
        val schoolName = view.findViewById<TextView>(R.id.schoolName)
        val fesImage = view.findViewById<ImageView>(R.id.fesImage)
        val favoriteBtn = view.findViewById<Button>(R.id.favoriteBtn)

        // テキストデータを挿入
        festivalName.text = getItem(position).getString("festivalName") ?: "NONE"
        date.text = getItem(position).getString("date") ?: "NONE"
        schoolName.text = getItem(position).getString("school") ?: "NONE"

        // お気に入りボタンの画像を設定する
        val favoriteObject = realm.where(FavoriteModel::class.java).equalTo("id", docId).findFirst()
        favoriteBtn.setBackgroundResource(R.drawable.star_none)
        favoriteObject?.let {
            // お気に入りに登録されている
            favoriteBtn.setBackgroundResource(R.drawable.star_fill)
        }

        // 画像データを挿入
        val path = "${docId}/festival-background-image.jpg"
        val imageRef = storage.child(path)
        imageRef.downloadUrl.addOnSuccessListener { Uri ->
            val imgURL = Uri.toString()
            Glide.with(view.context).load(imgURL).into(fesImage)
        }

        // タップ：お気に入り登録と解除
        favoriteBtn.setOnClickListener {
            if (favoriteObject == null){
                // 未登録なので追加
                realm.executeTransaction {  r : Realm ->
                    val favoriteItem = FavoriteModel()
                    favoriteItem.id = docId
                    favoriteItem.festivalname = getItem(position).getString("festivalName") ?: "NONE"
                    favoriteItem.date = getItem(position).getString("date") ?: "--/--(-)"
                    favoriteItem.school = getItem(position).getString("school") ?: "NONE"
                    favoriteItem.isFavorited = true
                    r.insertOrUpdate(favoriteItem)
                }
            } else {
                // 登録済みなので解除
                realm.executeTransaction {
                    favoriteObject.deleteFromRealm()
                }
            }
            // リストの更新
            super.notifyDataSetChanged()
        }

        // タップ：コンテンツホーム画面へ遷移
        view.setOnClickListener {
            val intent = Intent(view.context,ReadingHome::class.java)
            intent.putExtra("objectId",docId)
            view.context.startActivity(intent)
        }

        return view
    }
}