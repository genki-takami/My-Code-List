/*
 NoticeListViewControllerの拡張
 */

import UIKit

extension NoticeListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 201
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "readingNoticeCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = notices[indexPath.row].noticeTitle
        let date = cell.viewWithTag(2) as! UILabel
        date.text = notices[indexPath.row].strDate
        let content = cell.viewWithTag(3) as! UITextView
        content.text = notices[indexPath.row].noticeContent
        
        return cell
    }
}
