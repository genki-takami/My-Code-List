/*
 HomeTabViewControllerの拡張
 */

import UIKit

extension HomeTabViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewFromHomeSegue",sender: indexPath)
    }
}

extension HomeTabViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellNumber = 0
        // フィルターリストが１以上、または検索機能での不一致判定がtrueの場合はその数を返す
        if filteringDataArray.count > 0 || noneFlag {
            cellNumber = filteringDataArray.count
        } else {
            cellNumber = dataArray.count
        }
        
        return cellNumber
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さ
        tableView.rowHeight = 160
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTabListViewCell
        
        // フィルターリストが１以上、または検索機能での不一致判定がtrueの場合はその数を返す
        if filteringDataArray.count > 0 || noneFlag {
            cell.setFirebaseData(filteringDataArray[indexPath.row])
        } else {
            cell.setFirebaseData(dataArray[indexPath.row])
        }
        
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        cell.addGestureRecognizer(tapGesture)
        
        // お気に入りボタン
        cell.favoriteButton.addTarget(self, action:#selector(pushFavoriteButton(_:forEvent:)), for: .touchUpInside)

        return cell
    }
}
