/*
 MainViewControllerの拡張
 */

import UIKit
import SafariServices
import FirebaseFirestore

extension MainViewController {
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpCommentName() {
        if let myName = DataProcessing.getUserData("commentName") {
            commentName.text = myName
        } else {
            commentName.text = "匿名"
        }
    }
    
    // データの更新
    @objc func refrefhing(){
        isFirstFetch = true
        shops.removeAll()
        displays.removeAll()
        events.removeAll()
        notices.removeAll()
        maps.removeAll()
        databaseProperty.removeAll()
        self.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // 終了
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    func showBrowser(_ link: String) {
        if link.isEmpty {
            DisplayPop.error("Webページが見つかりません")
        } else {
            guard let url = URL(string: link) else { return }
            present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
    
    // コメントデータを受信する
    func getDocComments() {
        
        FetchData.fetchDocument(PathName.ListCommentID, self.uuid) { result in
            switch result {
            case .success(let data):
                self.comments.removeAll()
                let keys = [String](data.keys)
                for key in keys {
                    var commentPayload = data[key] as! [String:Any]
                    commentPayload["timestamp"] = (commentPayload["timestamp"] as! Timestamp).dateValue()
                    self.comments.append(commentPayload)
                }
                // 並び替える
                self.comments = self.comments.sorted(by: { (a,b) -> Bool in
                    return a["timestamp"] as! Date > b["timestamp"] as! Date
                })
            case .failure(let error):
                DisplayPop.error(error.localizedDescription)
            }
        }
    }
    
    // ショップデータを受信する
    func getDocShopsDisplays() {
        
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
                            "video": dataPayload.keys.contains("video") ? dataPayload["video"] as Any : false
                        ] as [String:Any]
                        isShop ? self.shops.append(dic) : self.displays.append(dic)
                    }
                case.failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
}
