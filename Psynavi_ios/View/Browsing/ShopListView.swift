/*
 ShopListViewControllerの拡張
 */

import UIKit

extension ShopListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "shopDetailsCellSegue",sender: nil)
    }
}

extension ShopListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 125
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "readingShopCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = shops[indexPath.row]["name"] as? String
        let place = cell.viewWithTag(2) as! UILabel
        place.text = shops[indexPath.row]["place"] as? String
        let manager = cell.viewWithTag(3) as! UILabel
        manager.text = shops[indexPath.row]["manager"] as? String
        let tag = cell.viewWithTag(4) as! UILabel
        tag.text = shops[indexPath.row]["tag"] as? String
        
        return cell
    }
}
