package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツのホームの処理
 */
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.widget.ArrayAdapter
import androidx.appcompat.app.AlertDialog
import com.bumptech.glide.Glide
import com.google.firebase.Timestamp
import com.google.firebase.firestore.SetOptions
import com.google.firebase.firestore.ktx.firestore
import com.google.firebase.ktx.Firebase
import com.google.firebase.storage.ktx.storage
import jp.creative.primefunc.genki.takami.psynavi.databinding.ReadingHomeBinding
import java.text.SimpleDateFormat
import java.util.*
import kotlin.collections.ArrayList

class ReadingHome : AppCompatActivity() {

    // 変数
    var fesLatitude: Double = 35.711455
    var fesLongitude: Double = 139.573323
    var url1: String? = null
    var url2: String? = null
    var upgrade: Boolean = false
    var mapFileUrl: String? = null
    var shopArray = ArrayList<Map<String,Any>>()
    var displayArray = ArrayList<Map<String,Any>>()
    var eventArray = ArrayList<Map<String,Any>>()
    var noticeArray = ArrayList<Map<String,Any>>()
    var markerData = mapOf<String,Any>()
    private var databaseProperty: Map<String,Any> = mutableMapOf()
    lateinit var binding: ReadingHomeBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ReadingHomeBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // IDを取得
        val fesId = intent.getStringExtra("objectId")

        // データベースを設定
        val db = Firebase.firestore
        val storageRef = Firebase.storage.reference

        // コメントネームの設定
        getSharedPreferences("userCommentName", Context.MODE_PRIVATE).getString("commentName","匿名")?.let { name: String ->
            binding.labelCommentName.text = name
        }

        // テキストデータを受信して表示
        val docRef = db.collection("campus-festival").document(fesId!!)
        docRef.get()
            .addOnSuccessListener { document ->
                val data = document.data
                if (data != null){
                    // データ取得
                    binding.rFestivalName.text = data["festivalName"] as? String ?: "NONE"
                    binding.rDateText.text = data["date"] as? String ?: "NONE"
                    binding.rPlaceText.text = data["school"] as? String ?: "NONE"
                    binding.rSloganText.text = data["slogan"] as? String ?: "NONE"
                    binding.rOwnerName.text = data["owner"] as? String ?: "NONE"
                    binding.rInformation.text = data["info"] as? String ?: "NONE"
                    fesLatitude = data["latitude"] as? Double ?: 35.711455
                    fesLongitude = data["longitude"] as? Double ?: 139.573323
                    (data["link"] as? Map<String,String>)?.let {
                        binding.rLinkText1.text = it["title1"] ?: "NONE"
                        this.url1 = it["url1"]
                        binding.rLinkText2.text = it["title2"] ?: "NONE"
                        this.url2 = it["url2"]
                    }
                    this.upgrade = data["upgrade"] as? Boolean ?: false
                    this.databaseProperty = (data["database"] as? Map<String,Any>) ?: mutableMapOf()
                    this.mapFileUrl = data["mapFileLink"] as? String ?: ""

                    // 画像データを取得して表示
                    val imageRef = storageRef.child(fesId)
                    val iconImageRef = imageRef.child("festival-icon.jpg")
                    val backImageRef = imageRef.child("festival-background-image.jpg")
                    this.databaseProperty["icon"]?.let {
                        iconImageRef.downloadUrl.addOnSuccessListener { Uri ->
                            val imgURL = Uri.toString()
                            Glide.with(this@ReadingHome).load(imgURL).into(binding.iconImage)
                        }
                    }
                    this.databaseProperty["background"]?.let {
                        backImageRef.downloadUrl.addOnSuccessListener { Uri ->
                            val imgURL = Uri.toString()
                            Glide.with(this@ReadingHome).load(imgURL).into(binding.backgroundImage)
                        }
                    }

                    // ショップと展示
                    if (this.databaseProperty["shop"] as Long > 0 || this.databaseProperty["display"] as Long > 0){
                        db.collection("CONTENTS").document(fesId).get()
                            .addOnSuccessListener {
                                it.data?.let { sd ->
                                    val list = it.get("list") as ArrayList<String>
                                    for (c in list){
                                        val thisOne = sd[c] as Map<String,Any>
                                        val isShop = thisOne["switchFlag"] as Boolean
                                        val dic: Map<String,Any> = mapOf(
                                            "name" to thisOne["name"] as String,
                                            "date" to thisOne["date"] as String,
                                            "place" to thisOne["place"] as String,
                                            "manager" to thisOne["manager"] as String,
                                            "managerInfo" to thisOne["managerInfo"] as String,
                                            "tag" to thisOne["tag"] as String,
                                            "info" to thisOne["info"] as String,
                                            "video" to if (thisOne.keys.contains("video")) thisOne["video"] as Boolean else false
                                        )
                                        if (isShop) this.shopArray.add(dic) else this.displayArray.add(dic)
                                    }
                                }
                            }
                            .addOnFailureListener {
                                val hud = CustomHUD(context = this@ReadingHome, text = "一部のデータの受信に失敗しました")
                                hud.dialog.show()
                            }
                    }

                    // イベント
                    if (this.databaseProperty["event"] as Long > 0){
                        db.collection("EVENTS").document(fesId).get()
                            .addOnSuccessListener {
                                it.data?.let { ev ->
                                    val list = it.get("list") as ArrayList<String>
                                    for (e in list){
                                        val thisOne = ev[e] as Map<String,Any>
                                        val dic: Map<String,Any> = mapOf(
                                            "eventTitle" to thisOne["eventTitle"] as String,
                                            "eventDate" to thisOne["eventDate"] as String,
                                            "caption" to thisOne["caption"] as String,
                                            "imageCaptions" to thisOne["imageCaptions"] as ArrayList<String>,
                                            "video" to if (thisOne.keys.contains("video")) thisOne["video"] as Boolean else false
                                        )
                                        this.eventArray.add(dic)
                                    }
                                }
                            }
                            .addOnFailureListener {
                                val hud = CustomHUD(context = this@ReadingHome, text = "一部のデータの受信に失敗しました")
                                hud.dialog.show()
                            }
                    }

                    // お知らせ
                    if (this.databaseProperty["notice"] as Long > 0){
                        db.collection("NOTICE").document(fesId).get()
                            .addOnSuccessListener {
                                it.data?.let { no ->
                                    val list = it.get("list") as ArrayList<String>
                                    val beforeNoticeArray = ArrayList<Map<String,Any>>()
                                    for (n in list){
                                        val thisOne = no[n] as Map<String,Any>
                                        val dic = hashMapOf(
                                            "noticeTitle" to thisOne["noticeTitle"] as String,
                                            "noticeContent" to thisOne["noticeContent"] as String,
                                            "date" to thisOne["date"] as com.google.firebase.Timestamp
                                        )
                                        beforeNoticeArray.add(dic)
                                    }
                                    for (notice in beforeNoticeArray){
                                        val timeStamp = notice["date"] as com.google.firebase.Timestamp
                                        val date = timeStamp.toDate()
                                        val new = hashMapOf(
                                            "noticeTitle" to notice["noticeTitle"] as String,
                                            "noticeContent" to notice["noticeContent"] as String,
                                            "date" to SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.JAPANESE).format(date)
                                        )
                                        if (this.noticeArray.isNotEmpty()){
                                            for ((index,value) in this.noticeArray.withIndex()){
                                                val existTimeStamp = value["date"] as com.google.firebase.Timestamp
                                                val date2 = existTimeStamp.toDate()
                                                if (date.after(date2)){
                                                    // 挿入する
                                                    this.noticeArray.add(index,new)
                                                    break
                                                } else if (index == this.noticeArray.lastIndex) {
                                                    // 最後尾に追加
                                                    this.noticeArray.add(new)
                                                }
                                            }
                                        } else {
                                            // ひとつ目は先頭に
                                            this.noticeArray.add(new)
                                        }
                                    }
                                }
                            }
                            .addOnFailureListener {
                                val hud = CustomHUD(context = this@ReadingHome, text = "一部のデータの受信に失敗しました")
                                hud.dialog.show()
                            }
                    }

                    // マップ
                    if (this.databaseProperty["marker"] as Long > 0){
                        db.collection("MAP").document(fesId).get()
                            .addOnSuccessListener {
                                it.data?.let { map: Map<String,Any> ->
                                    this.markerData = map
                                }
                            }
                            .addOnFailureListener {
                                val hud = CustomHUD(context = this@ReadingHome, text = "一部のデータの受信に失敗しました")
                                hud.dialog.show()
                            }
                    }

                    // プログレスバーを非表示にする
                    Handler(Looper.getMainLooper()).postDelayed({
                        binding.progressBar.visibility = android.widget.ProgressBar.INVISIBLE
                    }, 2000)
                } else {
                    // データがなかった場合
                    val hud = CustomHUD(context = this@ReadingHome, text = "データが存在しません！")
                    hud.dialog.show()
                    Handler(Looper.getMainLooper()).postDelayed({
                        // 画面を閉じる
                        finish()
                    }, 2000)
                }
            }
            .addOnFailureListener{
                // データの受信失敗
                val hud = CustomHUD(context = this@ReadingHome, text = "データの受信に失敗しました！")
                hud.dialog.show()
                Handler(Looper.getMainLooper()).postDelayed({
                    // 画面を閉じる
                    finish()
                }, 2000)
            }

        // タップ：投票イベントへ
        binding.voteBtn.setOnClickListener {
            val intent = Intent(this@ReadingHome,VoteList::class.java)
            intent.putExtra("objectId",fesId)
            intent.putExtra("upgrade",this.upgrade)
            startActivity(intent)
        }

        // タップ：ショップ一覧へ
        binding.shopBtn.setOnClickListener {
            val intent = Intent(this@ReadingHome,ReadingShopList::class.java)
            intent.putExtra("objectId",fesId)
            intent.putExtra("objectData", ShopData(this.shopArray))
            startActivity(intent)
        }

        // タップ：展示一覧へ
        binding.displayBtn.setOnClickListener {
            val intent = Intent(this@ReadingHome,ReadingDisplayList::class.java)
            intent.putExtra("objectId",fesId)
            intent.putExtra("objectData", DisplayData(this.displayArray))
            startActivity(intent)
        }

        // タップ：イベント一覧へ
        binding.eventBtn.setOnClickListener {
            val intent = Intent(this@ReadingHome,ReadingEventList::class.java)
            intent.putExtra("objectId",fesId)
            intent.putExtra("objectData", EventData(this.eventArray))
            startActivity(intent)
        }

        // タップ：マップへ
        binding.mapBtn.setOnClickListener {
            val intent = Intent(this@ReadingHome,ReadingMapView::class.java)
            intent.putExtra("latitude",fesLatitude)
            intent.putExtra("longitude",fesLongitude)
            intent.putExtra("objectData", MarkerData(this.markerData))
            intent.putExtra("mapFile", this.mapFileUrl)
            startActivity(intent)
        }

        // タップ：お知らせ一覧へ
        binding.noticeBtn.setOnClickListener {
            val intent = Intent(this@ReadingHome,ReadingNotice::class.java)
            intent.putExtra("objectData", NoticeData(this.noticeArray))
            startActivity(intent)
        }

        // タップ：URL1にジャンプ
        binding.rLinkText1.setOnClickListener {
            url1?.let {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(it))
                startActivity(intent)
            }
        }

        // タップ：URL2にジャンプ
        binding.rLinkText2.setOnClickListener {
            url2?.let {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse(it))
                startActivity(intent)
            }
        }

        // タップ：コメント一覧のダイアログを表示
        binding.btnCommentList.setOnClickListener {
            val comRef = db.collection("COMMENT").document(fesId)
            comRef.get()
                .addOnSuccessListener { document ->
                    val commentArray = ArrayList<String>()
                    document.data?.let {
                        // データ取得
                        val list = it.keys
                        for (i in list){
                            val oneComment = it[i] as Map<String,Any>
                            val sender = oneComment["sender"] as String
                            val content = oneComment["comment"] as String
                            val str = "＜${sender}さん＞\n　${content}\n"
                            commentArray.add(str)
                        }
                    }

                    val builder = AlertDialog.Builder(this@ReadingHome)

                    builder.setTitle("コメントリスト")
                    val adapter = ArrayAdapter(this@ReadingHome,android.R.layout.simple_list_item_1,commentArray)
                    builder.setAdapter(adapter){ _, _ ->
                        val hud = CustomHUD(context = this@ReadingHome, text = "コメントリストを表示中")
                        hud.dialog.show()
                    }
                    builder.setIcon(R.drawable.slogan)

                    builder.setPositiveButton("戻る",null)

                    // ダイアログを表示
                    val dialog = builder.create()
                    dialog.show()
                }
                .addOnFailureListener{
                    val hud = CustomHUD(context = this@ReadingHome, text = "データの受信に失敗しました！")
                    hud.dialog.show()
                }
        }

        // タップ：コメントを送信
        binding.btnPostComment.setOnClickListener {

            val builder = AlertDialog.Builder(this@ReadingHome)

            builder.setTitle("確認")
            builder.setMessage("コメントを送信しますか？\n送信したコメントはユーザー自身が削除することはできません。")

            // 送信
            builder.setPositiveButton("はい"){_, _ ->
                val sender = binding.labelCommentName.text.toString()
                val comment = binding.inputEditor.text.toString()

                if (comment.isNotEmpty()){
                    val uuid = UUID.randomUUID().toString()
                    val nestedData = hashMapOf(
                        "comment" to comment,
                        "sender" to sender,
                        "timestamp" to Timestamp(Date())
                    )
                    val data = hashMapOf(
                        uuid to nestedData
                    )

                    val ref = db.collection("COMMENT").document(fesId)
                    ref.set(data, SetOptions.merge())
                        .addOnSuccessListener {
                            val hud = CustomHUD(context = this@ReadingHome, text = "送信成功！")
                            hud.dialog.show()
                        }
                        .addOnFailureListener {
                            val hud = CustomHUD(context = this@ReadingHome, text = "送信失敗！")
                            hud.dialog.show()
                        }
                } else {
                    val hud = CustomHUD(context = this@ReadingHome, text = "文字を入力してください！")
                    hud.dialog.show()
                }
            }

            // キャンセル
            builder.setNegativeButton("キャンセル",null)

            // ダイアログを表示
            val dialog = builder.create()
            dialog.show()
        }
    }
}
