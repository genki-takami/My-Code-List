/*
 EventListViewControllerの拡張
 */

import UIKit

extension EventListViewController: UITableViewDelegate {
    
    /// セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventDetailsCellSegue", sender: nil)
    }
}

extension EventListViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// セルの高さを返す
        tableView.rowHeight = 67
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "readingEventsCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = events[indexPath.row]["eventTitle"] as? String
        let date = cell.viewWithTag(2) as! UILabel
        date.text = events[indexPath.row]["eventDate"] as? String
        
        return cell
    }
}
