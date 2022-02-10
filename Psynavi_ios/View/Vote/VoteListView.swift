/*
 VoteListViewControllerの拡張
 */

import UIKit

extension VoteListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let state = voteList[indexPath.row]["state"] as! String
        if state == "実施中" {
            performSegue(withIdentifier: "voteDetailSegue",sender: nil)
        } else {
            performSegue(withIdentifier: "voteResultSegue",sender: nil)
        }
    }
}

extension VoteListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return voteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 60
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "voteListCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = voteList[indexPath.row]["name"] as? String ?? "NaN"
        let tag = cell.viewWithTag(2) as! UILabel
        tag.text = voteList[indexPath.row]["state"] as? String ?? "作成中"
        
        return cell
    }
}
