/*
 構造体
 */

import Foundation

/// これは構造体じゃない
final class Festival: NSObject {
    var id: String = ""
    var name: String = ""
    var place: String = ""
    var date: String = ""
    var isFavorite: Bool = false
}

struct Notice {
    let festivalName: String
    let noticeTitle: String?
    let date: Date
    let noticeContent: String?
    let strDate: String
    init(attributes: [String:Any]) {
        self.festivalName = attributes["name"] as! String
        self.noticeTitle = attributes["title"] as? String
        self.date = attributes["date"] as! Date
        self.noticeContent = attributes["content"] as? String
        self.strDate = attributes["strDate"] as! String
    }
}
