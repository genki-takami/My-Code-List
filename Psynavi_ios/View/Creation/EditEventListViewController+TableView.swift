/*
 EditEventListViewControllerの拡張
 */

import UIKit

extension EditEventListViewController: UITableViewDelegate {
    
    /// セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventsCellSegue", sender: nil)
    }
}

extension EditEventListViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// セルの高さを返す
        tableView.rowHeight = 56
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let event = eventArray[indexPath.row]
        
        cell.textLabel?.text = event.eventTitle
        cell.detailTextLabel?.text = event.eventDate
        
        return cell
    }
    
    /// セルの削除を可能にする
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    /// 企画イベントデータをデータベースから削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            RealmTask.delete(eventArray[indexPath.row], RealmModel.event) { result in
                switch result {
                case .success(_):
                    self.eventArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
