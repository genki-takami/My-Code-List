package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツのイベント詳細画面のグリッド画像のアダプター
 */
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.util.Base64
import android.view.LayoutInflater
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import jp.creative.primefunc.genki.takami.psynavi.databinding.ReadingGridViewBinding
import java.io.ByteArrayOutputStream
import com.bumptech.glide.load.DataSource
import com.bumptech.glide.load.engine.GlideException
import com.bumptech.glide.request.RequestListener
import com.bumptech.glide.request.target.Target

class ReadingEventGridAdapter(private val customList: ArrayList<CollectionModel>) : RecyclerView.Adapter<ReadingEventGridAdapter.ViewHolder>() {

    // ViewHolderクラスの作成
    class ViewHolder(
        val binding: ReadingGridViewBinding
    ) : RecyclerView.ViewHolder(binding.root) {
        val image = binding.gridImage
        val name: TextView = binding.gridText
    }

    // リストの数を返す
    override fun getItemCount() = customList.size

    // レイアウトの設定
    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = ReadingGridViewBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return ViewHolder(view)
    }

    // レイアウトの作成
    override fun onBindViewHolder(viewHolder: ViewHolder, position: Int) {
        val data = customList[position]

        // データを挿入
        var bitmapString = ""
        viewHolder.name.text = data.name
        Glide.with(viewHolder.itemView)
            .load(data.image)
            .listener(object: RequestListener<Drawable>{
                override fun onLoadFailed(
                    e: GlideException?, model: Any?,
                    target: Target<Drawable>?, isFirstResource: Boolean
                ): Boolean {
                    return false
                }
                override fun onResourceReady(
                    resource: Drawable?, model: Any?,
                    target: Target<Drawable>?, dataSource: DataSource?,
                    isFirstResource: Boolean): Boolean {
                    // 完了
                    resource?.let {
                        val drawable = it as BitmapDrawable
                        val bitmap = drawable.bitmap
                        val baos = ByteArrayOutputStream()
                        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, baos)
                        bitmapString = Base64.encodeToString(baos.toByteArray(), Base64.DEFAULT)
                    }
                    return false
                }
            })
            .into(viewHolder.image)

        // タップ：拡大画面へ遷移
        viewHolder.itemView.setOnClickListener { view ->
            val intent = Intent(view.context,ReadingEventShowImage::class.java)
            intent.putExtra("image", bitmapString)
            intent.putExtra("caption", data.caption)
            view.context.startActivity(intent)
        }
    }
}

// グリッド画像のデータモデル
data class CollectionModel(
    val image: String,  // 画像
    val name: String,   // ラベル
    val caption: String // キャプション
)