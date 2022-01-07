package jp.creative.primefunc.genki.takami.psynavi
/*
コンテンツの地図の処理
 */
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import androidx.core.app.ActivityCompat.OnRequestPermissionsResultCallback
import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.appcompat.app.AlertDialog
import androidx.core.content.ContextCompat
import jp.creative.primefunc.genki.takami.psynavi.PermissionUtils.isPermissionGranted
import jp.creative.primefunc.genki.takami.psynavi.PermissionUtils.requestPermission
import com.google.android.gms.maps.CameraUpdateFactory
import com.google.android.gms.maps.GoogleMap
import com.google.android.gms.maps.OnMapReadyCallback
import com.google.android.gms.maps.SupportMapFragment
import com.google.android.gms.maps.model.BitmapDescriptorFactory
import com.google.android.gms.maps.model.LatLng
import com.google.android.gms.maps.model.MarkerOptions
import jp.creative.primefunc.genki.takami.psynavi.databinding.ReadingMapViewBinding

class ReadingMapView : AppCompatActivity(), OnMapReadyCallback, OnRequestPermissionsResultCallback {

    // 共有オブジェクト
    companion object {
        const val LOCATION_PERMISSION_REQUEST_CODE = 1
    }

    // 変数
    var obj = mapOf<String,Any>()
    var latitude: Double = 35.711455
    var longitude: Double = 139.573323
    var mapFileUrl: String? = null
    private lateinit var map: GoogleMap
    lateinit var binding: ReadingMapViewBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ReadingMapViewBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // フラグメントマネージャーの設定
        val mapFragment = supportFragmentManager.findFragmentById(R.id.map) as SupportMapFragment
        mapFragment.getMapAsync(this)

        // データと緯度経度を取得
        latitude = intent.getDoubleExtra("latitude",35.711455)
        longitude = intent.getDoubleExtra("longitude",139.573323)
        mapFileUrl = intent.getStringExtra("mapFile")
        val data = intent.getSerializableExtra("objectData")
        if (data is MarkerData){
            obj = data.data
        }

        // タップ：地図の種類を変更
        binding.changeBtn.setOnClickListener {
            map.mapType = when (map.mapType){
                GoogleMap.MAP_TYPE_NORMAL -> GoogleMap.MAP_TYPE_HYBRID
                GoogleMap.MAP_TYPE_HYBRID -> GoogleMap.MAP_TYPE_NORMAL
                else -> GoogleMap.MAP_TYPE_NORMAL
            }
        }

        // タップ：案内マップをブラウザで表示
        binding.mapFileBtn.setOnClickListener {
            this.mapFileUrl?.let { mURL: String ->
                if (mURL.isNotEmpty()){
                    val dialog = AlertDialog.Builder(this@ReadingMapView)
                        .setTitle("説明")
                        .setMessage("アカウントを選択する場合がありますが、その際は案内マップのビューアに必要なので選択してください")
                        .setPositiveButton("案内マップを見る"){ _, _ ->
                            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(mURL))
                            startActivity(intent)
                        }
                        .create()
                    dialog.show()
                } else {
                    val hud = CustomHUD(context = this@ReadingMapView, text = "案内マップが投稿されていません")
                    hud.dialog.show()
                }
            }
        }
    }

    // 地図の設定
    override fun onMapReady(googleMap: GoogleMap) {
        map = googleMap

        // 位置情報の確認と許可
        enableMyLocation()

        // 座標と地図タイプを設定
        val location = LatLng(latitude, longitude)
        map.mapType = GoogleMap.MAP_TYPE_NORMAL

        // データを受信
        val list = obj["list"] as ArrayList<String>
        // ピンを追加していく
        for (i in list){
            val pin = obj[i] as Map<String,Any>
            val pinLocation = LatLng(pin["latitude"] as Double,pin["longitude"] as Double)
            val pinImage: Int = when (pin["pinImage"] as String){
                "food" -> R.drawable.food
                "display" -> R.drawable.display
                "event" -> R.drawable.event
                "attraction" -> R.drawable.attraction
                "bench" -> R.drawable.bench
                "smoke" -> R.drawable.smoke
                "trash" -> R.drawable.trash
                "toilet" -> R.drawable.toilet
                "info" -> R.drawable.info
                else -> R.drawable.mappin
            }
            val height = 150
            val width = 150
            val bitmap = BitmapFactory.decodeResource(this.resources,pinImage)
            val marker = Bitmap.createScaledBitmap(bitmap,width,height,false)
            val markerOption = MarkerOptions()
                .position(pinLocation)
                .title(pin["title"] as String)
                .snippet(pin["subtitle"] as String)
                .icon(BitmapDescriptorFactory.fromBitmap(marker))
            map.addMarker(markerOption)
        }
        map.moveCamera(CameraUpdateFactory.newLatLngZoom(location, 17.0f))
    }

    // パーミッションの確認
    private fun enableMyLocation() {
        if (!::map.isInitialized) return

        if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            // 許可されている
            map.isMyLocationEnabled = true
        } else {
            // 許可されていない
            requestPermission(this, LOCATION_PERMISSION_REQUEST_CODE, Manifest.permission.ACCESS_FINE_LOCATION, true)
        }
    }

    // パーミッションの識別
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        if (requestCode != LOCATION_PERMISSION_REQUEST_CODE) {
            // ミスマッチ
            return
        }
        if (isPermissionGranted(permissions, grantResults, Manifest.permission.ACCESS_FINE_LOCATION)) {
            // 確認にいく
            enableMyLocation()
        }
    }
}
