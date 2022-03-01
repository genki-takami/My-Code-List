/*
 ReportListViewControllerの拡張
 */

import UIKit

extension ReportListViewController: UITableViewDelegate {
    
    /// セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "edit", sender: nil)
    }
}

extension ReportListViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// セルの高さ
        tableView.rowHeight = 100
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath)
        
        /// 負傷者
        let injured = cell.viewWithTag(1) as! UILabel
        injured.text = reports[indexPath.row].injured
        /// 報告者
        let reporter = cell.viewWithTag(2) as! UILabel
        reporter.text = "報告者：" + reports[indexPath.row].reporter
        /// 日時
        let date = cell.viewWithTag(3) as! UILabel
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: reports[indexPath.row].date)
        date.text = dateString
        /// 診断
        let diagnosis = cell.viewWithTag(4) as! UILabel
        diagnosis.text = reports[indexPath.row].diagnosis
        /// 負傷部位画像
        let image = cell.viewWithTag(5) as! UIImageView
        image.image = UIImage(data: reports[indexPath.row].image)
        
        return cell
    }
    
    /// セルは削除可能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    /// データベースから削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            RealmTask.delete(reports[indexPath.row]) { result in
                switch result {
                case .success(let text):
                    Modal.showSuccess(text)
                    self.reports.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
}
