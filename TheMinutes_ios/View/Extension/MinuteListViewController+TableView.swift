/*
 MinuteListViewControllerの拡張
 */

import UIKit

extension MinuteListViewController: UITableViewDelegate {
    
    /// セルのタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "minuteEditSegue",sender: nil)
    }
}

extension MinuteListViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return minutes.count
    }

    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "minuteCell", for: indexPath)
        
        cell.textLabel?.text = minutes[indexPath.row].meetingName
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: minutes[indexPath.row].date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }
    
    /// セルは削除可能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    /// データベースから削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            RealmTask.delete(minutes[indexPath.row], RealmModel.minute) { result in
                switch result {
                case .success(let text):
                    Modal.showSuccess(text)
                    self.minutes.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
