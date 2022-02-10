/*
 NoticeTabViewControllerの拡張
 */

import UIKit
import FirebaseFirestore

extension NoticeTabViewController {
    
    // データを更新
    @objc func refreshNotices() {
        self.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.noticeList.refreshControl?.endRefreshing()
        }
    }
    
    // タスクのチェック、並び替え
    func checkTask(_ taskCounter: Int) {
        if taskCounter == 0 {
            if notices.count >= 2 {
                // 日付順に並び替え
                notices = notices.sorted(by: { (a,b) -> Bool in
                    return a.date! > b.date!
                })
            }
            noticeList.reloadData()
            DisplayPop.dismiss()
        }
    }
    
    // カスタムポップアップを返す
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    // 受信したお知らせデータを形成する
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
            // データを形成する
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
