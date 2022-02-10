/*
 FavoriteTabViewControllerの拡張
 */

import UIKit

extension FavoriteTabViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewFromFavoriteSegue",sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // メニューを表示
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let delete = UIAction(title: "削除", image: UIImage(systemName: "trash.fill"), identifier: nil) { action in
                self.tableView(tableView, commit: UITableViewCell.EditingStyle.delete, forRowAt: indexPath)
            }
            return UIMenu(title: "アクション", image: nil, identifier: nil, children: [delete])
        }
    }
}

extension FavoriteTabViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 100
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTabListViewCell
        cell.setData(favorites[indexPath.row])
        
        // セルのタップ検知
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // お気に入りをデータベースから削除する
        if editingStyle == .delete {
            
            DataProcessing.delete(favorites[indexPath.row], RealmModel.favorite) { result in
                switch result {
                case .success(let text):
                    DisplayPop.success(text)
                    self.favorites.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
    
    // セルをタップした時に実行
    @objc func goToDetail(sender: MyTapGestureRecognizer) {
        tableView(favoriteList, didSelectRowAt: sender.indexValue!)
    }
}
