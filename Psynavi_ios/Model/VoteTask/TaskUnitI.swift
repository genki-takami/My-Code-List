/*
 VoteListViewControllerの拡張
 */

import UIKit

extension VoteListViewController {
    
    // 投票イベントデータを取得する
    func getVotes() {
        
        if upgrade {
            // データあり(課金済み)
            if let uid = uid {
                
                DisplayPop.show()
                
                FetchData.fetchDatabase("festivals/\(uid)") { result in
                    switch result {
                    case .success(let data):
                        self.organizeVotes(data)
                    case .failure(let error):
                        DisplayPop.error(error.localizedDescription)
                    }
                }
            }
        } else {
            // データなし(非課金)
            refresh()
        }
    }
    
    // テーブルをリフレッシュする
    private func refresh() {
        
        DispatchQueue.main.async {
            self.voteTable.reloadData()
            if self.voteList.isEmpty {
                self.voteTitle.text = "投票イベントなし"
            }
        }
    }
    
    // 投票データを整理する
    private func organizeVotes(_ data: [String:AnyObject]) {
        let keys = [String](data.keys)
        
        if !keys.isEmpty {
            for key in keys {
                let event = data[key] as! [String:Any]
                // データセットを取得
                if let dataset = event["dataset"] as? [String:Any] {
                    let lists = dataset["lists"] as! [[String:String]]
                    var choises = [String]()
                    for list in lists {
                        choises.append(list["title"]!)
                    }
                    let voteObject: [String:Any] = [
                        "name": dataset["name"] as! String,
                        "info": dataset["info"] as! String,
                        "lists": choises,
                        "choise": dataset["choise"] as! Bool,
                        "state": (dataset["finish"] as! Bool) ? "終了" : "実施中",
                    ]
                    self.voteList.append(voteObject)
                }
                // 結果を取得
                if let result = event["result"] as? [String:Any] {
                    self.resultList.append(result)
                } else {
                    // まだ誰も投票していない
                    let noResult = ["all":"Nobody vote"]
                    self.resultList.append(noResult)
                }
            }
        }
        
        refresh()
        DisplayPop.dismiss()
    }
}
