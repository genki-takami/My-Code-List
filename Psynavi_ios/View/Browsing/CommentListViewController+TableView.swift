/*
 CommentListViewControllerの拡張
 */

import UIKit

extension CommentListViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// セルの高さを返す
        tableView.rowHeight = 140
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentListCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = "\(comments[indexPath.row]["sender"] as! String)さんより"
        let comment = cell.viewWithTag(2) as! UITextView
        comment.text = comments[indexPath.row]["comment"] as? String
        comment.layer.cornerRadius = 10
        
        return cell
    }
}
