package jp.creative.primefunc.genki.takami.psynavi
/*
インテントでオブジェクトを渡すためのデータクラス
 */
import java.io.Serializable

// 投票結果
data class VoteResultData (
    val data: MutableMap<String,Any>
): Serializable

// ショップ
data class ShopData (
    val data: ArrayList<Map<String,Any>>
): Serializable

// 展示
data class DisplayData (
    val data: ArrayList<Map<String,Any>>
): Serializable

// イベント
data class EventData (
    val data: ArrayList<Map<String,Any>>
): Serializable

// お知らせ
data class NoticeData (
    val data: ArrayList<Map<String,Any>>
): Serializable

// マップ
data class MarkerData (
    val data: Map<String,Any>
): Serializable