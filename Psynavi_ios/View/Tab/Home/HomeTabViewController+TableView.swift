/*
 HomeTabViewControllerの拡張
 */

import UIKit

extension HomeTabViewController: UITableViewDelegate {
    /// セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewFromHomeSegue",sender: indexPath)
    }
    
    /// UITableViewを更新
    func reloadTable() {
        festivalList.reloadData()
    }
}

extension HomeTabViewController: UITableViewDataSource {
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellNumber = 0
        /// フィルターリストが１以上、または検索機能での不一致判定がtrueの場合はその数を返す
        if filteringDataArray.count > 0 || noneFlag {
            cellNumber = filteringDataArray.count
        } else {
            cellNumber = dataArray.count
        }
        
        return cellNumber
    }

    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// セルの高さ
        tableView.rowHeight = 160
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeTabListViewCell
        
        /// フィルターリストが１以上、または検索機能での不一致判定がtrueの場合はその数を返す
        if filteringDataArray.count > 0 || noneFlag {
            cell.setFirebaseData(filteringDataArray[indexPath.row])
        } else {
            cell.setFirebaseData(dataArray[indexPath.row])
        }
        
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        cell.addGestureRecognizer(tapGesture)
        
        /// お気に入りボタン
        cell.favoriteButton.addTarget(self, action:#selector(tapFavoriteButton(_:forEvent:)), for: .touchUpInside)

        return cell
    }
    
    /// セルをタップした時に実行
    @objc func goToDetail(sender: MyTapGestureRecognizer) {
        
        tableView(festivalList, didSelectRowAt: sender.indexValue!)
    }
    
    /// セルのお気に入りボタンのステータスを変更する
    @objc func tapFavoriteButton(_ sender: UIButton, forEvent event: UIEvent) {
        
        let indexPath = festivalList.indexPathForRow(at: (event.allTouches?.first!.location(in: festivalList))!)
        onClickStar(sender, indexPath)
    }
}
