/*
 HomeTabViewControllerの拡張
 */

import UIKit
import RealmSwift

extension HomeTabViewController {
    
    // セルをタップした時に実行
    @objc func goToDetail(sender: MyTapGestureRecognizer) {
        tableView(festivalList, didSelectRowAt: sender.indexValue!)
    }
    
    // セルのお気に入りボタンのステータスを変更する
    @objc func pushFavoriteButton(_ sender: UIButton, forEvent event: UIEvent) {
        // タップされたセルのインデックスを求める
        let indexPath = festivalList.indexPathForRow(at: (event.allTouches?.first!.location(in: festivalList))!)

        var isNotFavorite = true
        let favorites = DataProcessing.findAll(RealmModel.favorite) as! Results<Favorite>
        let data = Festival()
        
        if filteringDataArray.count > 0 {
            // フィルター済みであった場合
            setUpData(data, filteringDataArray[indexPath!.row])
        } else {
            setUpData(data, dataArray[indexPath!.row])
        }
        
        if favorites.count > 0 {
            // タップされたデータのuuidとお気に入りリストのidを照合
            if let match = favorites.first(where: { $0.id == data.id }) {
                // お気に入りされていた場合
                DataProcessing.delete(match, RealmModel.favorite) { result in
                    isNotFavorite = false
                    switch result {
                    case .success(let text):
                        if !text.isEmpty {
                            // お気に入りを解除する
                            self.updateFavorite(isNotFavorite, indexPath!.row)
                            // 画像を空のスターに変更
                            sender.setImage(UIImage(systemName: "star"), for: .normal)
                        }
                    case .failure(let error):
                        DisplayPop.error(error.localizedDescription)
                    }
                }
            }
        }
        
        if isNotFavorite {
            // お気に入りに登録
            let new = Favorite()
            new.id = data.id
            new.festivalName = data.name
            new.festivalDate = data.date
            new.festivalPlace = data.place
            new.isFavorite = data.isFavorite
            
            DataProcessing.add(new, [:], EditMode.add, RealmModel.favorite) { result in
                switch result {
                case .success(let text):
                    if !text.isEmpty {
                        // お気に入りにする
                        self.updateFavorite(true, indexPath!.row)
                        // 画像をお気に入りスターに変更
                        sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
                    }
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
        
        // tableViewをリロード
        festivalList.reloadData()
    }
    
    private func setUpData(_ data: Festival, _ cellData: HomeTabCellData) {
        data.id = cellData.uuid
        data.name = cellData.festivalName
        data.date = cellData.date
        data.place = cellData.place
        data.isFavorite = cellData.isFavorite
    }
    
    private func updateFavorite(_ isFavorite: Bool, _ index: Int) {
        if filteringDataArray.count > 0 {
            filteringDataArray[index].isFavorite = isFavorite
        } else {
            dataArray[index].isFavorite = isFavorite
        }
    }
}
