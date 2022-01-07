package jp.seikei.judo.genki.takami.reportofsports_injuryapp
/*
レポートの追加と編集の処理
 */
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import androidx.appcompat.app.AppCompatActivity
import android.Manifest
import android.app.Activity
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.provider.MediaStore
import android.util.Base64
import android.view.inputmethod.InputMethodManager
import android.widget.DatePicker
import android.widget.TimePicker
import io.realm.Realm
import java.io.ByteArrayOutputStream
import jp.seikei.judo.genki.takami.reportofsports_injuryapp.databinding.ActivityReportAddBinding
import java.util.*

class ReportAdd : AppCompatActivity() {

    // リクエストコード
    companion object {
        const val PERMISSIONS_REQUEST_CODE = 100
        const val CHOOSER_REQUEST_CODE = 200
    }

    // 変数
    var mYear = 0
    var mMonth = 0
    var mDay = 0
    var mHour = 0
    var mMinutes = 0
    var reportId:Int = 0
    var report: ReportModel? = null
    var imageUri: Uri? = null
    lateinit var realm: Realm
    lateinit var binding: ActivityReportAddBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityReportAddBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // レポートidを受け取る
        reportId = intent.getIntExtra("reportData", -1)

        // データベースの設定
        realm = Realm.getDefaultInstance()

        // 入力エリア設定
        report = realm.where(ReportModel::class.java).equalTo("id", reportId).findFirst()
        val calendar = Calendar.getInstance()
        if (report == null){
            // 新規作成の場合
            title = "レポートの新規作成"
            mYear = calendar.get(Calendar.YEAR)
            mMonth = calendar.get(Calendar.MONTH)
            mDay = calendar.get(Calendar.DAY_OF_MONTH)
            mHour = calendar.get(Calendar.HOUR_OF_DAY)
            mMinutes = calendar.get(Calendar.MINUTE)
        } else {
            // 更新の場合
            title = "レポートの編集"
            binding.editInjuredPersonName.setText(report!!.person)
            binding.editReporterName.setText(report!!.reporter)
            binding.editInjuredPlace.setText(report!!.place)
            binding.editInjuredPosition.setText(report!!.position)
            binding.editDiagnosis.setText(report!!.diagnosis)
            binding.editCause.setText(report!!.cause)
            binding.editAfterEffect.setText(report!!.afterEffect)

            if (report!!.picture.isNotEmpty()) {
                val bytes = Base64.decode(report!!.picture, Base64.DEFAULT)
                // 画像データを挿入
                val image = BitmapFactory.decodeByteArray(bytes, 0, bytes.size).copy(Bitmap.Config.ARGB_8888, true)
                binding.picture.setImageBitmap(image)
            }

            calendar.time = report!!.dateAndTime
            mYear = calendar.get(Calendar.YEAR)
            mMonth = calendar.get(Calendar.MONTH)
            mDay = calendar.get(Calendar.DAY_OF_MONTH)
            mHour = calendar.get(Calendar.HOUR_OF_DAY)
            mMinutes = calendar.get(Calendar.MINUTE)

            val dateString = mYear.toString() + "/" + String.format("%02d", mMonth + 1) + "/" + String.format("%02d", mDay)
            val timeString = String.format("%02d", mHour) + ":" + String.format("%02d", mMinutes)

            binding.dateBtn.text = dateString
            binding.timesBtn.text = timeString
        }

        // タップ：日付の処理
        binding.dateBtn.setOnClickListener{
            val datePickerDialog = DatePickerDialog(this, DialogDateButtonClickLister(), mYear, mMonth, mDay)
            datePickerDialog.show()
        }

        //タップ：時間の処理
        binding.timesBtn.setOnClickListener{
            val timePickerDialog = TimePickerDialog(this, DialogTimeButtonClickLister(), mHour, mMinutes, false)
            timePickerDialog.show()
        }

        // タップ：保存処理
        binding.saveBtn.setOnClickListener{ view ->
            // キーボードが出てたら閉じる
            val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

            // データベースに保存
            realm.executeTransaction{ r : Realm ->
                if (report == null){
                    // 新規追加
                    val reportData = ReportModel()

                    // idを付与
                    val results = r.where(ReportModel::class.java).findAll()
                    reportData.id =
                        if (results.max("id") != null){
                            results.max("id")!!.toInt() + 1
                        } else {
                            0
                        }

                    // データを挿入
                    reportData.person = binding.editInjuredPersonName.text.toString()
                    reportData.reporter = binding.editReporterName.text.toString()
                    reportData.dateAndTime = GregorianCalendar(mYear, mMonth, mDay, mHour, mMinutes).time
                    reportData.place = binding.editInjuredPlace.text.toString()
                    reportData.position = binding.editInjuredPosition.text.toString()
                    reportData.diagnosis = binding.editDiagnosis.text.toString()
                    reportData.cause = binding.editCause.text.toString()
                    reportData.afterEffect = binding.editAfterEffect.text.toString()
                    reportData.picture = createImageString()
                    // 書き出し
                    r.insertOrUpdate(reportData)
                } else {
                    // 更新
                    report!!.person = binding.editInjuredPersonName.text.toString()
                    report!!.reporter = binding.editReporterName.text.toString()
                    report!!.dateAndTime = GregorianCalendar(mYear, mMonth, mDay, mHour, mMinutes).time
                    report!!.place = binding.editInjuredPlace.text.toString()
                    report!!.position = binding.editInjuredPosition.text.toString()
                    report!!.diagnosis = binding.editDiagnosis.text.toString()
                    report!!.cause = binding.editCause.text.toString()
                    report!!.afterEffect = binding.editAfterEffect.text.toString()
                    report!!.picture = createImageString()
                    // 書き出し
                    r.insertOrUpdate(report!!)
                }
            }
            finish()
        }

        // タップ：画像挿入処理
        binding.picture.setOnClickListener{ _ ->
            // SDKバージョンの識別
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                // パーミッションの許可状態を確認
                if (checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED) {
                    // 許可されている
                    showIntent()
                } else {
                    // 許可されていないので許可ダイアログを表示
                    requestPermissions(arrayOf(Manifest.permission.WRITE_EXTERNAL_STORAGE), PERMISSIONS_REQUEST_CODE)
                }
            } else {
                // SDKが6.0より前
                showIntent()
            }
        }
    }

    // 画像データをテキスト化する
    private fun createImageString(): String {
        var bitmapString = ""
        val drawable = binding.picture.drawable as? BitmapDrawable
        if (drawable != null){
            val bitmap = drawable.bitmap
            val baos = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.JPEG, 80, baos)
            bitmapString = Base64.encodeToString(baos.toByteArray(), Base64.DEFAULT)
        }
        return bitmapString
    }

    // 取得した画像を表示する
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == CHOOSER_REQUEST_CODE) {

            if (resultCode != Activity.RESULT_OK) {
                imageUri?.let {
                    // カメラで撮影した画像のパスを削除
                    contentResolver.delete(it, null, null)
                    imageUri = null
                }
                return
            }

            // カメラで撮影orギャラリーからの画像を取得
            val uri = if (data == null || data.data == null) imageUri else data.data

            // URIからBitmapを取得する
            val image: Bitmap
            try {
                val cr = contentResolver
                val inputStream = cr.openInputStream(uri!!)
                image = BitmapFactory.decodeStream(inputStream)
                inputStream!!.close()
            } catch (e: Exception) {
                return
            }

            // BitmapをImageViewに設定する
            binding.picture.setImageBitmap(image)

            imageUri = null
        }
    }

    // 許可を受け取る
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        when (requestCode) {
            PERMISSIONS_REQUEST_CODE -> {
                if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    // 許可
                    showIntent()
                }
            }
            else -> return
        }
    }

    // ギャラリーモーダル・カメラを起動する
    private fun showIntent() {
        // ギャラリーから選択
        val galleryIntent = Intent(Intent.ACTION_GET_CONTENT)
        galleryIntent.type = "image/*"
        galleryIntent.addCategory(Intent.CATEGORY_OPENABLE)

        // カメラで撮影
        val cameraIntent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        val filename = System.currentTimeMillis().toString() + ".jpg"
        val values = ContentValues()
        values.put(MediaStore.Images.Media.TITLE, filename)
        values.put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
        // 撮影した画像の保存先のパスを取得して渡す
        imageUri = contentResolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, values)
        cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, imageUri)

        // ギャラリー選択のインテントを与えてcreateChooserメソッドを呼ぶ
        val chooserIntent = Intent.createChooser(galleryIntent, "画像を取得")
        // [EXTRA_INITIAL_INTENTS]にカメラ撮影のインテントを追加
        chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, arrayOf(cameraIntent))
        // リクエストコードと共にインテントを起動
        startActivityForResult(chooserIntent, CHOOSER_REQUEST_CODE)
    }

    // シャットダウン処理
    override fun onDestroy() {
        super.onDestroy()

        // データベースのシャットダウン
        realm.close()
    }

    // DatePickerのリスナー
    private inner class DialogDateButtonClickLister : DatePickerDialog.OnDateSetListener {
        override fun onDateSet(p0: DatePicker, year: Int, month: Int, day: Int) {
            mYear = year
            mMonth = month
            mDay = day
            val dateString = mYear.toString() + "/" + String.format("%02d", mMonth + 1) + "/" + String.format("%02d", mDay)
            binding.dateBtn.text = dateString
        }
    }

    // TimePickerのリスナー
    private inner class DialogTimeButtonClickLister : TimePickerDialog.OnTimeSetListener {
        override fun onTimeSet(p0: TimePicker?, hour: Int, min: Int) {
            mHour = hour
            mMinutes= min
            val timeString = String.format("%02d", mHour) + ":" + String.format("%02d", mMinutes)
            binding.timesBtn.text = timeString
        }
    }
}
