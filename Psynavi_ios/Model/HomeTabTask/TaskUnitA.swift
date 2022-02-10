/*
 HomeTabViewControllerの拡張
 */

import Foundation
import RealmSwift

extension HomeTabViewController {
    
    // キーボードをしまう
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // プロパティをリフレッシュする
    @objc func refreshData(){
        FetchData.resetListener()
        dataArray.removeAll()
        filteringDataArray = []
        matchItems.removeAll()
        noneFlag = false
        viewWillAppear(true)
        receiveCatalog()
        DispatchQueue.main.async {
            self.festivalList.refreshControl?.endRefreshing()
        }
    }
    
    // データを受信する
    func fetchData() {
        
        FetchData.fetchSnapshot { result in
            switch result {
            case .success(let data):
                self.dataArray = data
            case .failure(let error):
                DisplayPop.error(error.localizedDescription)
            }
            // tableViewの表示を更新する
            self.festivalList.reloadData()
        }
    }
    
    // お気に入りボタンのステータス更新
    func starCheck() {
        
        let favorites = DataProcessing.findAll(RealmModel.favorite) as! Results<Favorite>
        if !dataArray.isEmpty {
            dataArray.forEach {
                likeFilter(data: $0, likes: favorites)
            }
        }
        if !filteringDataArray.isEmpty {
            filteringDataArray.forEach {
                likeFilter(data: $0, likes: favorites)
            }
        }
        // tableViewの表示を更新する
        festivalList.reloadData()
    }
    
    // お気に入りステータス変換
    private func likeFilter(data: HomeTabCellData, likes: Results<Favorite>) {
        
        if likes.count > 0 {
            if let _ = likes.first(where: { $0.id == data.uuid }) {
                // お気に入りの場合
                data.isFavorite = true
            } else {
                // お気に入りでない場合
                data.isFavorite = false
            }
        } else {
            // お気に入りが１つもない
            data.isFavorite = false
        }
    }
}
