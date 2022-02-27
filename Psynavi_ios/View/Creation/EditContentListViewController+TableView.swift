/*
 EditContentListViewControllerの拡張
 */

import UIKit

extension EditContentListViewController: UITableViewDelegate {
    
    /// セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "contentsCellSegue", sender: nil)
    }
}

extension EditContentListViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArray.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// セルの高さを返す
        tableView.rowHeight = 90
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath)
        
        let content = contentsArray[indexPath.row]
        let name = cell.viewWithTag(1) as! UILabel
        name.text = content.name
        let place = cell.viewWithTag(2) as! UILabel
        place.text = content.place
        let manager = cell.viewWithTag(3) as! UILabel
        manager.text = content.manager
        let tag = cell.viewWithTag(4) as! UILabel
        tag.text = content.tag
        
        return cell
    }
    
    /// セルの削除を可能にする
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    /// コンテンツデータをデータベースから削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            RealmTask.delete(contentsArray[indexPath.row], RealmModel.content) { result in
                switch result {
                case .success(_):
                    self.contentsArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
