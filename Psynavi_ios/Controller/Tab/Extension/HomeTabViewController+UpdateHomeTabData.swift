/*
 HomeTabViewControllerの拡張
 */

import UIKit
import RealmSwift

extension HomeTabViewController: UpdateHomeTabData {
    
    /// UITableViewを更新する
    func refreshData() {
        
        FetchData.resetListener()
        dataArray.removeAll()
        filteringDataArray = []
        matchItems.removeAll()
        noneFlag = false
        viewWillAppear(true)
        fetchCatalog()
        
        DispatchQueue.main.async {
            self.festivalList.refreshControl?.endRefreshing()
        }
    }
    
    /// お気に入りボタンのステータス更新
    func updateStar() {
        
        let favorites = RealmTask.findAll(RealmModel.favorite) as! Results<Favorite>
        
        if !dataArray.isEmpty {
            dataArray.forEach {
                setFavoriteStatus(data: $0, likes: favorites)
            }
        }
        
        if !filteringDataArray.isEmpty {
            filteringDataArray.forEach {
                setFavoriteStatus(data: $0, likes: favorites)
            }
        }
        
        reloadTable()
    }
    
    /// お気に入りステータスをセット
    private func setFavoriteStatus(data: HomeTabCellData, likes: Results<Favorite>) {
        
        if likes.count > 0 {
            if let _ = likes.first(where: { $0.id == data.uuid }) {
                /// お気に入りの場合
                data.isFavorite = true
            } else {
                /// お気に入りでない場合
                data.isFavorite = false
            }
        } else {
            /// お気に入りが１つもない
            data.isFavorite = false
        }
    }
    
    /// お気に入りボタンをタップした時の処理
    func onClickStar(_ sender: UIButton, _ indexPath: IndexPath?) {
        
        var isNotFavorite = true
        let favorites = RealmTask.findAll(RealmModel.favorite) as! Results<Favorite>
        let data = Festival()
        
        if filteringDataArray.count > 0 {
            /// 検索済みであった場合
            setUpBasicData(data, filteringDataArray[indexPath!.row])
        } else {
            setUpBasicData(data, dataArray[indexPath!.row])
        }
        
        if favorites.count > 0 {
            /// タップされたデータのuuidとお気に入りリストのidを照合
            if let match = favorites.first(where: { $0.id == data.id }) {
                /// お気に入りされていた場合
                RealmTask.delete(match, RealmModel.favorite) { result in
                    isNotFavorite = false
                    switch result {
                    case .success(_):
                        /// お気に入りを解除する
                        self.updateFavoriteStatus(isNotFavorite, indexPath!.row)
                        /// 画像を空のスターに変更
                        sender.setImage(UIImage(systemName: "star"), for: .normal)
                    case .failure(let error):
                        Modal.showError(String(describing: error))
                    }
                }
            }
        }
        
        if isNotFavorite {
            /// お気に入りに登録
            let new = Favorite()
            new.id = data.id
            new.festivalName = data.name
            new.festivalDate = data.date
            new.festivalPlace = data.place
            new.isFavorite = data.isFavorite
            
            RealmTask.add(new, [:], EditMode.add, RealmModel.favorite) { result in
                switch result {
                case .success(_):
                    /// お気に入りにする
                    self.updateFavoriteStatus(true, indexPath!.row)
                    /// 画像をお気に入りスターに変更
                    sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
        
        reloadTable()
    }
    
    /// 文化祭の基本的なデータをセット
    private func setUpBasicData(_ data: Festival, _ cellData: HomeTabCellData) {
        
        data.id = cellData.uuid
        data.name = cellData.festivalName
        data.date = cellData.date
        data.place = cellData.place
        data.isFavorite = cellData.isFavorite
    }
    
    /// お気に入りのステータスを更新する
    private func updateFavoriteStatus(_ isFavorite: Bool, _ index: Int) {
        
        if filteringDataArray.count > 0 {
            filteringDataArray[index].isFavorite = isFavorite
        } else {
            dataArray[index].isFavorite = isFavorite
        }
    }
}
