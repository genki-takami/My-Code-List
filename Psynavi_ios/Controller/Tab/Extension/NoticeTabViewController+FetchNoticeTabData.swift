/*
 NoticeTabViewControllerの拡張
 */

import RealmSwift
import FirebaseFirestore

extension NoticeTabViewController: FetchNoticeTabData {
    
    /// お知らせデータを受信する
    func receiveNotices(_ favorites: Results<Favorite>) {
        
        var taskCounter = favorites.count
        Modal.show()
        
        for favorite in favorites {
            /// お気に入り登録されたコンテンツのお知らせデータを受信
            FetchData.fetchDocument(PathName.ListNoticeID, favorite.id) { result in
                switch result {
                case .success(let data):
                    let task = self.makeData(data, favorite.festivalName)
                    taskCounter -= task
                    self.checkTask(taskCounter)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                    /// すでに削除されているorエラー
                    taskCounter -= 1
                    self.checkTask(taskCounter)
                }
            }
        }
    }
    
    /// タスクのチェック、並び替え
    func checkTask(_ taskCounter: Int) {
        if taskCounter == 0 {
            if notices.count >= 2 {
                /// 日付順に並び替え
                notices = notices.sorted(by: { (a,b) -> Bool in
                    return a.date! > b.date!
                })
            }
            reloadTable()
            Modal.dismiss()
        }
    }
    
    /// 受信したお知らせデータを形成してタスクを完了する
    func makeData(_ data: [String:Any], _ festivalName: String) -> Int {
        
        let noticeIDList: [String] = data["list"] as! [String]
        for id in noticeIDList {
            let payload = data[id] as? [String : Any]
            let timestamp: Timestamp! = payload!["date"] as? Timestamp
            let dateValue = timestamp.dateValue()
            let f = DateFormatter()
            f.locale = Locale(identifier: "ja_JP")
            f.dateStyle = .long
            f.timeStyle = .short
            let date = f.string(from: dateValue)
            /// データを形成する
            let elements: [String:Any] = [
                "name": festivalName,
                "title": payload!["noticeTitle"] as! String,
                "date": dateValue,
                "content": payload!["noticeContent"] as! String,
                "strDate": date,
            ]
            let notice: Notice = Notice(attributes: elements)
            let tuple = (notice.festivalName, notice.noticeTitle, notice.date, notice.noticeContent, notice.strDate)
            notices.append(tuple)
        }
        
        return 1
    }
}
