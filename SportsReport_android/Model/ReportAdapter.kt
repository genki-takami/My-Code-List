package jp.seikei.judo.genki.takami.reportofsports_injuryapp
/*
外傷レポートのリストアダプター
 */
import android.content.Context
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.BaseAdapter
import android.widget.TextView
import java.text.SimpleDateFormat
import java.util.*

class ReportAdapter(context: Context) : BaseAdapter() {

    // 変数
    var inflater: LayoutInflater
    var reportList = mutableListOf<ReportModel>()

    // 初期化
    init {
        this.inflater = LayoutInflater.from(context)
    }

    // リストの数を返す
    override fun getCount(): Int {
        return reportList.size
    }

    // リストのデータを返す
    override fun getItem(position: Int): ReportModel {
        return reportList[position]
    }

    // リストのidを返す
    override fun getItemId(position: Int): Long {
        return 0
    }

    // リストの中身を返す
    override fun getView(position: Int, convertView: View?, parent: ViewGroup): View {
        val view: View = convertView ?: inflater.inflate(R.layout.report_list, parent, false)

        val injuredPerson = view.findViewById<TextView>(R.id.injuredPerson)
        val smallDateAndTimes = view.findViewById<TextView>(R.id.smallDateAndTimes)
        val diagnosisName = view.findViewById<TextView>(R.id.diagnosisName)
        val reporter = view.findViewById<TextView>(R.id.reporterText)
        val preview = view.findViewById<TextView>(R.id.previewOrEditButton)

        injuredPerson.text = getItem(position).person
        smallDateAndTimes.text = SimpleDateFormat("yyyy/MM/dd HH:mm", Locale.JAPANESE).format(getItem(position).dateAndTime)
        diagnosisName.text = getItem(position).diagnosis
        val reporterString = "報告者：" + getItem(position).reporter
        reporter.text = reporterString
        preview.text = "閲覧"

        return view
    }
}