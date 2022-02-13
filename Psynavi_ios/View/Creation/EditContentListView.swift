/*
 EditContentListViewControllerの拡張
 */

import UIKit

extension EditContentListViewController: UITableViewDelegate {
    // セルのタップ時の処理を返す
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "contentsCellSegue", sender: nil)
    }
}

extension EditContentListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    // Deleteボタン
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // データベースから削除する
        if editingStyle == .delete {
            
            DataProcessing.delete(contentsArray[indexPath.row], RealmModel.content) { result in
                switch result {
                case .success(_):
                    self.contentsArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
}
