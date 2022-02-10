/*
 HomeTabViewControllerの拡張
 */

import UIKit

extension HomeTabViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        guard let text = searchBar.text else { return }
        
        // 初期化(dataArrayの参照を解除するために[]を代入してリセット)
        filteringDataArray = []
        noneFlag = false
        
        // 無記入であればスナップショットを格納
        if text.isEmpty{
            filteringDataArray = dataArray
            festivalList.reloadData()
            return
        }
        // スナップショットをカタログからフィルターする
        filteringDataArray = dataArray.filter { data -> Bool in
            return data.festivalName.lowercased().contains(text.lowercased())
        }
        
        // スナップショットになかったら、カタログから検索する
        if filteringDataArray.count > 0 {
            festivalList.reloadData()
        } else {
            // カタログ(サーバーにあるデータ群)でフィルターする
            matchItems = nameList.filter { item -> Bool in
                return item.lowercased().contains(text.lowercased())
            }
            
            if matchItems.count > 0 {
                fetchHitData()
            } else {
                // firestoreにもない
                noneFlag = true
                DisplayPop.error("「\(text)」に一致するものはありませんでした。")
                festivalList.reloadData()
            }
        }
    }
}
