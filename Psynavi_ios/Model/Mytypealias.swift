/*
 作成したタイプエイリアス
 */

import Foundation

typealias ResultHandler<T> = (Result<T, Error>) -> Void

typealias NoticeParam = (name: String, noticeTitle: String?, date: Date?, noticeContent: String?, strDate: String?)
