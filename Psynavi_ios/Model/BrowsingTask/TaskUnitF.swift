/*
 MainViewControllerの拡張
 */

import UIKit
import FirebaseFirestore

extension MainViewController {
    
    // databasePropertyを参照して他のデータも持ってくる
    func fetchAllData() {
        // 画像データを表示
        setIconAndBack()
        // コメント
        getDocComments()
        // ショップと展示
        getDocShopsDisplays()
        // イベント
        getDocEvents()
        // お知らせ
        getDocNotices()
        //マップ
        getDocMaps()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            DisplayPop.dismiss()
            self.isFirstFetch = false
        }
    }
    
    // イベントデータを受信する
    private func getDocEvents() {
        let eventCount = databaseProperty["event"] as! Int
        
        if eventCount > 0 {
            
            FetchData.fetchDocument(PathName.ListEventsID, uuid) { result in
                switch result {
                case .success(let data):
                    
                    let eventArray: [String] = data["list"] as! [String]
                    for event in eventArray {
                        let dataPayload = data[event] as! [String : Any]
                        let dic = [
                            "id": data["documentID"] as! String,
                            "eventTitle": dataPayload["eventTitle"] as Any,
                            "eventDate": dataPayload["eventDate"] as Any,
                            "caption": dataPayload["caption"] as Any,
                            "imageCaptions": dataPayload["imageCaptions"] as Any,
                            "video": dataPayload.keys.contains("video") ? dataPayload["video"] as Any : false
                        ] as [String:Any]
                        self.events.append(dic)
                    }
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
    
    // お知らせデータを受信する
    private func getDocNotices() {
        let noticeCount = databaseProperty["notice"] as! Int
        
        if noticeCount > 0 {
            
            FetchData.fetchDocument(PathName.ListNoticeID, uuid) { result in
                switch result {
                case .success(let data):
                    
                    let noticeArray: [String] = data["list"] as! [String]
                    for notice in noticeArray {
                        let dataPayload = data[notice] as! [String : Any]
                        let dateValue = (dataPayload["date"] as! Timestamp).dateValue()
                        let f = DateFormatter()
                        f.locale = Locale(identifier: "ja_JP")
                        f.dateStyle = .long
                        f.timeStyle = .short
                        let date = f.string(from: dateValue)
                        let elements: [String:Any] = [
                            "name": data["documentID"] as! String,
                            "title": dataPayload["noticeTitle"] as! String,
                            "date": dateValue,
                            "content": dataPayload["noticeContent"] as! String,
                            "strDate": date,
                        ]
                        let notice: Notice = Notice(attributes: elements)
                        let tuple = (notice.festivalName, notice.noticeTitle, notice.date, notice.noticeContent, notice.strDate)
                        self.notices.append(tuple)
                    }
                    // 並び替える
                    if self.notices.count >= 2 {
                        self.notices = self.notices.sorted(by: { (a,b) -> Bool in
                            return a.date! > b.date!
                        })
                    }
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
    
    // マップデータを受信する
    private func getDocMaps() {
        let markerCount = databaseProperty["marker"] as! Int
        
        if markerCount > 0 {
            
            FetchData.fetchDocument(PathName.ListMapID, uuid) { result in
                switch result {
                case .success(let data):
                    self.maps = data
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
}
