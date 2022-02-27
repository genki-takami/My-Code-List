/*
 MainViewControllerの拡張
 */

import FirebaseFirestore
import FirebaseStorageUI

extension MainViewController: FetchMainViewData {
    
    /// databasePropertyを参照して他のデータも持ってくる
    func fetchAllData() {
        /// 画像データを表示
        setIconAndBack()
        /// コメント
        fetchDocComments()
        /// ショップと展示
        fetchDocShopsDisplays()
        /// イベント
        fetchDocEvents()
        /// お知らせ
        fetchDocNotices()
        ///マップ
        fetchDocMaps()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Modal.dismiss()
            self.isFirstFetch = false
        }
    }
    
    /// アイコン画像と背景画像を設置
    private func setIconAndBack() {
        
        if databaseProperty["icon"] != nil {
            iconImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let iconRef = FetchData.getReference(databaseProperty["icon"] as! String)
            iconImage.sd_setImage(with: iconRef)
        }
        
        if databaseProperty["background"] != nil {
            backgroundImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
            let backRef = FetchData.getReference(databaseProperty["background"] as! String)
            backgroundImage.sd_setImage(with: backRef)
        }
    }
    
    /// コメントデータを受信する
    func fetchDocComments() {
        
        FetchData.fetchDocument(PathName.ListCommentID, self.uuid) { result in
            switch result {
            case .success(let data):
                self.comments.removeAll()
                let keys = [String](data.keys)
                
                for key in keys {
                    if key == "documentID" {
                        continue
                    }
                    var commentPayload = data[key] as! [String:Any]
                    commentPayload["timestamp"] = (commentPayload["timestamp"] as! Timestamp).dateValue()
                    self.comments.append(commentPayload)
                }
                /// 並び替える
                self.comments = self.comments.sorted(by: { (a,b) -> Bool in
                    return a["timestamp"] as! Date > b["timestamp"] as! Date
                })
            case .failure(let error):
                Modal.showError(String(describing: error))
            }
        }
    }
    
    /// ショップ/展示データを受信する
    private func fetchDocShopsDisplays() {
        
        let shopCount = databaseProperty["shop"] as! Int
        let displayCount = databaseProperty["display"] as! Int
        
        if shopCount > 0 || displayCount > 0 {
            
            FetchData.fetchDocument(PathName.ListContentsID, uuid) { result in
                switch result {
                case.success(let data):
                    let contents: [String] = data["list"] as! [String]
                    
                    for content in contents {
                        let dataPayload = data[content] as! [String:Any]
                        let isShop = dataPayload["switchFlag"] as! Bool
                        
                        let dic = [
                            "id": data["documentID"] as! String,
                            "name": dataPayload["name"] as Any,
                            "date": dataPayload["date"] as Any,
                            "place": dataPayload["place"] as Any,
                            "manager": dataPayload["manager"] as Any,
                            "managerInfo": dataPayload["managerInfo"] as Any,
                            "tag": dataPayload["tag"] as Any,
                            "info": dataPayload["info"] as Any,
                            "video": dataPayload.keys.contains("video") ? dataPayload["video"] as Any : false,
                        ] as [String:Any]
                        
                        isShop ? self.shops.append(dic) : self.displays.append(dic)
                    }
                case.failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
    
    /// イベントデータを受信する
    private func fetchDocEvents() {
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
                            "video": dataPayload.keys.contains("video") ? dataPayload["video"] as Any : false,
                        ] as [String:Any]
                        
                        self.events.append(dic)
                    }
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
    
    /// お知らせデータを受信する
    private func fetchDocNotices() {
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
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
    
    /// マップデータを受信する
    private func fetchDocMaps() {
        let markerCount = databaseProperty["marker"] as! Int
        
        if markerCount > 0 {
            
            FetchData.fetchDocument(PathName.ListMapID, uuid) { result in
                switch result {
                case .success(let data):
                    self.maps = data
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
