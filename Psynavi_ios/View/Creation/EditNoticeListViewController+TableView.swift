/*
 EditNoticeListViewControllerの拡張
 */

import UIKit

extension EditNoticeListViewController: UITableViewDelegate {
    
    /// セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "noticeCellSegue", sender: nil)
    }
}

extension EditNoticeListViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// セルの高さを返す
        tableView.rowHeight = 56
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath)
        let notice = noticeArray[indexPath.row]
        
        /// 日付のフォーマットを変更
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateStyle = .long
        f.timeStyle = .short
        let date = f.string(from: notice.date)
        
        cell.textLabel?.text = notice.noticeTitle
        cell.detailTextLabel?.text = date
        
        return cell
    }
    
    /// セルの削除を可能にする
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    /// お知らせデータをデータベースから削除する
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            RealmTask.delete(noticeArray[indexPath.row], RealmModel.notice) { result in
                switch result {
                case .success(_):
                    self.noticeArray.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
