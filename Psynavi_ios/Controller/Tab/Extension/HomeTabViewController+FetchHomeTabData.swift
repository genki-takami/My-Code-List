/*
 HomeTabViewControllerの拡張
 */

import UIKit

extension HomeTabViewController: FetchHomeTabData {
    
    /// スナップショットデータを受信する
    func fetchSnapshot() {
        
        FetchData.fetchSnapshot { result in
            switch result {
            case .success(let data):
                self.dataArray = data
            case .failure(let error):
                Modal.showError(String(describing: error))
            }
            
            self.reloadTable()
        }
    }
    
    /// カタログデータ(文化祭名がリスト化されたもの)を受信
    func fetchCatalog() {
        
        nameList.removeAll()
        
        FetchData.fetchDocument(PathName.CatalogPath, "nameList") { result in
            switch result {
            case .success(let data):
                /// 検索の時に使用するカタログ
                self.nameList += data["list"] as! [String]
                
                /// ニュースレターが既読か判定
                let letterId = data["id"] as! String
                guard let _ = UserDefaultsTask.getUserData("newsletter\(letterId)") else { return }
                
                /// 未読の場合はアラートで表示
                let message = data["newsletter"] as! String
                let alertController = UIAlertController(title: "お知らせ", message: message, preferredStyle: .alert)
                let actionOk = UIAlertAction(title: "OK", style: .default) { action in
                    /// 既読する
                    UserDefaultsTask.setUserData(letterId, "newsletter\(letterId)")
                }
                alertController.addAction(actionOk)
                self.present(alertController, animated: true, completion: nil)
                
            case .failure(let error):
                Modal.showError(String(describing: error))
            }
        }
    }
    
    /// 検索にヒットしたデータを受信
    func fetchHitData() {
        
        Modal.show()
        var taskCounter = matchItems.count
        
        for item in matchItems {
            FetchData.fetchDocuments(PathName.FestivalPath, "festivalName", item, 1) { result in
                switch result {
                case .success(let data):
                    if !(data.isEmpty) {
                        /// １つしか該当しない、取得したデータを格納
                        let document = data.documents.first!
                        self.filteringDataArray.append(HomeTabCellData(document: document))
                        taskCounter -= 1
                        self.showSearchingResult(taskCounter)
                    } else {
                        /// すでに削除済み(カタログにはあるがデータはない)
                        taskCounter -= 1
                        self.showSearchingResult(taskCounter)
                    }
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
    
    /// タスクカウンターを減らして、最後にUITableViewを更新
    private func showSearchingResult(_ taskCounter: Int) {
        
        if taskCounter == 0 {
            reloadTable()
            /// 検索に引っかかったアイテムがすべて削除済みであった場合
            if filteringDataArray.isEmpty {
                noneFlag = true
                reloadTable()
                Modal.showError("一致するものはありませんでした。")
            }
        }
    }
}
