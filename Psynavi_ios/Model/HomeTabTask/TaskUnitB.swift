/*
 HomeTabViewControllerの拡張
 */

import UIKit

extension HomeTabViewController {
    
    // カタログを受信
    func receiveCatalog() {
        
        nameList.removeAll()
        
        FetchData.fetchDocument(PathName.CatalogPath, "nameList") { result in
            switch result {
            case .success(let data):
                // 検索の時に使用するカタログ
                self.nameList += data["list"] as! [String]
                // ニュースレターが既読か判定
                let letterId = data["id"] as! String
                guard let _ = UserDefaults.standard.string(forKey: "newsletter\(letterId)") else { return }
                // 未読の場合はアラートで表示
                let message = data["newsletter"] as! String
                let alertController = UIAlertController(title: "お知らせ", message: message, preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "OK", style: .default) { action in
                    // 既読
                    UserDefaults.standard.setValue(letterId, forKey: "newsletter\(letterId)")
                }
                alertController.addAction(actionOk)
                self.present(alertController, animated: true, completion: nil)
            case .failure(let error):
                DisplayPop.error(error.localizedDescription)
            }
        }
    }
    
    // 検索にヒットしたデータを受信
    func fetchHitData() {
        
        DisplayPop.show()
        var taskCounter = matchItems.count
        
        for item in matchItems {
            FetchData.fetchDocuments(PathName.FestivalPath, "festivalName", item, 1) { result in
                switch result {
                case .success(let data):
                    if !(data.isEmpty) {
                        // １つしか該当しない、取得したデータを格納
                        let document = data.documents.first!
                        self.filteringDataArray.append(HomeTabCellData(document: document))
                        taskCounter -= 1
                        self.showSearchingResult(taskCounter)
                    } else {
                        // すでに削除済み(カタログにはあるがデータはない)
                        taskCounter -= 1
                        self.showSearchingResult(taskCounter)
                    }
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
    
    // タスクカウンターを減らして、最後にtableViewを更新
    private func showSearchingResult(_ taskCounter: Int) {
        
        if taskCounter == 0 {
            festivalList.reloadData()
            // 検索に引っかかったアイテムがすべて削除済みであった場合
            if filteringDataArray.isEmpty {
                noneFlag = true
                festivalList.reloadData()
                DisplayPop.error("一致するものはありませんでした。")
            }
        }
    }
}
