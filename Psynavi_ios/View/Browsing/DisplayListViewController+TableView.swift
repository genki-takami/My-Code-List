/*
 DisplayListViewControllerの拡張
 */

import UIKit

extension DisplayListViewController: UITableViewDelegate {
    
    /// セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "displayDetailsCellSegue",sender: nil)
    }
}

extension DisplayListViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displays.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// セルの高さを返す
        tableView.rowHeight = 125
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "readingDisplayCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = displays[indexPath.row]["name"] as? String
        let place = cell.viewWithTag(2) as! UILabel
        place.text = displays[indexPath.row]["place"] as? String
        let manager = cell.viewWithTag(3) as! UILabel
        manager.text = displays[indexPath.row]["manager"] as? String
        let tag = cell.viewWithTag(4) as! UILabel
        tag.text = displays[indexPath.row]["tag"] as? String
        
        return cell
    }
}
