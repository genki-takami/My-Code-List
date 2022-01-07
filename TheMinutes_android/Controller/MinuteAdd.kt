package jp.seikei.judo.genki.takami.theminutesapp
/*
議事録の追加・共有処理
 */
import android.app.AlertDialog
import android.app.DatePickerDialog
import android.app.TimePickerDialog
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.content.Context
import android.view.inputmethod.InputMethodManager
import io.realm.Realm
import android.content.Intent
import android.widget.DatePicker
import android.widget.TimePicker
import jp.seikei.judo.genki.takami.theminutesapp.databinding.ActivityMinuteAddBinding
import java.util.*

class MinuteAdd : AppCompatActivity() {

    // 変数
    var mYear = 0
    var mMonth = 0
    var mDay = 0
    var mHour = 0
    var mMinutes = 0
    var folderId:Int = 0
    var minuteId:Int = 0
    var minute: MinuteModel? = null
    lateinit var realm: Realm
    lateinit var binding: ActivityMinuteAddBinding

    // 読み込み
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMinuteAddBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // フォルダーidを取得
        folderId = intent.getIntExtra(EXTRA_FOLDER, -1)

        // 議事録idを取得
        minuteId = intent.getIntExtra(EXTRA_MINUTE, -1)

        // タップ：日付の処理
        binding.dateButton.setOnClickListener { _ ->
            val datePickerDialog = DatePickerDialog(this, DialogDateButtonClickLister(), mYear, mMonth, mDay)
            datePickerDialog.show()
        }

        // タップ：時間の処理
        binding.timesButton.setOnClickListener { _ ->
            val timePickerDialog = TimePickerDialog(this, DialogTimeButtonClickLister(), mHour, mMinutes, false)
            timePickerDialog.show()
        }

        // タップ：保存処理
        binding.doneButton.setOnClickListener {view ->

            // キーボードを閉じる
            val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

            // 議事録を保存して終了
            addMinutes()
            finish()
        }

        // タップ：共有処理
        binding.shareButton.setOnClickListener {view ->

            // キーボードを閉じる
            val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

            // 議事録を保存して終了し、共有モーダルを出す
            addMinutes()
            share()
            finish()
        }

        // データベースの設定
        realm = Realm.getDefaultInstance()

        // 入力エリア設定
        minute = realm.where(MinuteModel::class.java).equalTo("id", minuteId).findFirst()
        val calendar = Calendar.getInstance()
        if (minute == null) {
            // 新規作成の場合
            title = "議事録の追加"

            mYear = calendar.get(Calendar.YEAR)
            mMonth = calendar.get(Calendar.MONTH)
            mDay = calendar.get(Calendar.DAY_OF_MONTH)
            mHour = calendar.get(Calendar.HOUR_OF_DAY)
            mMinutes = calendar.get(Calendar.MINUTE)
        } else {
            // 更新の場合
            title = "議事録の編集"

            binding.meetingNameEditText.setText(minute!!.meetingName)
            binding.minuteTakerEditText.setText(minute!!.minuteTaker)
            binding.topicEditText.setText(minute!!.topic)
            binding.placeEditText.setText(minute!!.place)
            binding.attendeeEditText.setText(minute!!.attendee)
            binding.meetingContentsEditText.setText(minute!!.meetingContents)
            binding.decisionEditText.setText(minute!!.decision)
            binding.noteEditText.setText(minute!!.note)

            calendar.time = minute!!.dateAndTime
            mYear = calendar.get(Calendar.YEAR)
            mMonth = calendar.get(Calendar.MONTH)
            mDay = calendar.get(Calendar.DAY_OF_MONTH)
            mHour = calendar.get(Calendar.HOUR_OF_DAY)
            mMinutes = calendar.get(Calendar.MINUTE)

            val dateString = mYear.toString() + "/" + String.format("%02d", mMonth + 1) + "/" + String.format("%02d", mDay)
            val timeString = String.format("%02d", mHour) + ":" + String.format("%02d", mMinutes)

            binding.dateButton.text = dateString
            binding.timesButton.text = timeString
        }

        // タップ：登録した場所を選択して自動記入
        binding.registeredPlace.setOnClickListener { view ->

            // キーボードを閉じる
            val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

            // リストダイアログの生成
            val builder = AlertDialog.Builder(this@MinuteAdd)
            builder.setTitle("場所を選択してください")

            // データベースから会議場所データを参照
            val results = realm.where(PlaceModel::class.java).equalTo("parentGroupId",folderId).findAll()
            val places = realm.copyFromRealm(results)

            // 会議場所名だけをリストに追加
            val placeNames = mutableListOf<String>()
            for (i in places){
                placeNames.add(i.placeName)
            }

            // Array配列に変換
            val ary = Array(size = placeNames.size, init = { index ->
                placeNames[index]
            })

            // チェックボックスリストの準備
            val checkboxItems = Array(placeNames.size){ false }

            // 選択したチェックボックスから自動入力オブジェクトを判別
            builder.setMultiChoiceItems(ary, null){ _, which, isChecked ->
                checkboxItems[which] = isChecked
            }

            // 完了
            builder.setPositiveButton("完了"){ _, _ ->
                val placeObjects = checkboxItems.mapIndexed { index, isChecked ->
                    when(isChecked){
                        true -> ary[index]
                        false -> null
                    }
                }.filterNotNull().joinToString("、")

                // 入力エリアに挿入する
                if (placeObjects.isNotEmpty()){
                    val existText = binding.placeEditText.text.toString()
                    val str = existText + placeObjects
                    binding.placeEditText.setText(str)
                }
            }

            // キャンセル
            builder.setNegativeButton("キャンセル", null)

            // リストダイアログの表示
            val dialog = builder.create()
            dialog.show()
        }

        // タップ：登録したメンバーを選択して自動記入
        binding.registeredMember.setOnClickListener{ view ->

            // キーボードを閉じる
            val im = getSystemService(Context.INPUT_METHOD_SERVICE) as InputMethodManager
            im.hideSoftInputFromWindow(view.windowToken, InputMethodManager.HIDE_NOT_ALWAYS)

            // リストダイアログの生成
            val builder = AlertDialog.Builder(this@MinuteAdd)
            builder.setTitle("出席者を選択してください")

            // データベースから出席者データを参照
            val results = realm.where(MemberModel::class.java).equalTo("parentGroupId",folderId).findAll()
            val members = realm.copyFromRealm(results)

            // 出席者名だけをリストに追加
            val memberNames = mutableListOf<String>()
            for (i in members){
                memberNames.add(i.memberName)
            }

            // Array配列に変換
            val ary = Array(size = memberNames.size, init = { index ->
                memberNames[index]
            })

            // チェックボックスリストの準備
            val checkboxItems = Array(memberNames.size){ false }

            // 選択したチェックボックスから自動入力オブジェクトを判別
            builder.setMultiChoiceItems(ary, null){ _, which, isChecked ->
                checkboxItems[which] = isChecked
            }

            // 完了
            builder.setPositiveButton("完了"){ _, _ ->
                val memberObjects = checkboxItems.mapIndexed { index, isChecked ->
                    when(isChecked){
                        true -> ary[index]
                        false -> null
                    }
                }.filterNotNull().joinToString("、")

                // 入力エリアに挿入する
                if (memberObjects.isNotEmpty()){
                    val existText = binding.attendeeEditText.text.toString()
                    val str = existText + memberObjects
                    binding.attendeeEditText.setText(str)
                }
            }

            // キャンセル
            builder.setNegativeButton("キャンセル", null)

            // リストダイアログの表示
            val dialog = builder.create()
            dialog.show()
        }
    }

    // 議事録の追加/編集
    private fun addMinutes() {
        realm.executeTransaction { r: Realm ->
            // オブジェクトの新規作成
            if (minute == null) {
                minute = MinuteModel()
                // idを付与する
                val results = realm.where(MinuteModel::class.java).findAll()
                minute!!.id =
                    if (results.max("id") != null) {
                        results.max("id")!!.toInt() + 1
                    } else {
                        0
                    }
            }

            // 値を代入していく
            minute!!.meetingName = binding.meetingNameEditText.text.toString()
            minute!!.minuteTaker = binding.minuteTakerEditText.text.toString()
            minute!!.topic = binding.topicEditText.text.toString()
            minute!!.place = binding.placeEditText.text.toString()
            minute!!.attendee = binding.attendeeEditText.text.toString()
            minute!!.meetingContents = binding.meetingContentsEditText.text.toString()
            minute!!.decision = binding.decisionEditText.text.toString()
            minute!!.note = binding.noteEditText.text.toString()
            minute!!.dateAndTime = GregorianCalendar(mYear, mMonth, mDay, mHour, mMinutes).time
            minute!!.parentGroupId = folderId

            // 書き出す
            r.insertOrUpdate(minute!!)
        }
    }

    // 議事録内容を共有
    private fun share(){
        minute?.let {
            // データを参照してリスト化
            val zList = arrayOf(
                if (it.meetingName.isNotEmpty()) it.meetingName else "なし",
                if (it.minuteTaker.isNotEmpty()) it.minuteTaker else "なし",
                if (it.topic.isNotEmpty()) it.topic else "なし",
                mYear.toString() + "/" + String.format("%02d", mMonth + 1) + "/" + String.format("%02d", mDay),
                String.format("%02d", mHour) + ":" + String.format("%02d", mMinutes),
                if (it.place.isNotEmpty()) it.place else "なし",
                if (it.attendee.isNotEmpty()) it.attendee else "なし",
                if (it.meetingContents.isNotEmpty()) it.meetingContents else "なし",
                if (it.decision.isNotEmpty()) it.decision else "なし",
                if (it.note.isNotEmpty()) it.note else "なし"
            )

            // テキストデータの作成
            val intentMinutes =
                "【会議名】\n" + zList[0] + "\n" +
                "【書記】\n" + zList[1] + "\n" +
                "【議題】\n" + zList[2] + "\n" +
                "【日時】\n" + zList[3] + zList[4] + "\n" +
                "【場所】\n" + zList[5] + "\n" +
                "【出席者】\n" + zList[6] + "\n" +
                "【会議内容】\n" + zList[7] + "\n" +
                "【決定事項】\n" + zList[8] + "\n" +
                "【備考】\n" + zList[9]

            // 共有オブジェクトの作成
            val sendIntent: Intent = Intent().apply {
                action = Intent.ACTION_SEND
                putExtra(Intent.EXTRA_TEXT, intentMinutes)
                type = "text/plain"
            }

            // 共有フォームを表示
            val shareIntent = Intent.createChooser(sendIntent, null)
            startActivity(shareIntent)
        }
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
            binding.dateButton.text = dateString
        }
    }

    // TimePickerのリスナー
    private inner class DialogTimeButtonClickLister : TimePickerDialog.OnTimeSetListener {
        override fun onTimeSet(p0: TimePicker?, hour: Int, min: Int) {
            mHour = hour
            mMinutes= min
            val timeString = String.format("%02d", mHour) + ":" + String.format("%02d", mMinutes)
            binding.timesButton.text = timeString
        }
    }
}