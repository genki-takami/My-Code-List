/*
 コメントリストの処理
 */

import UIKit

final class CommentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // 変数
    var dataArray: [[String:Any]] = []
    @IBOutlet weak var commentTable: UITableView!
    
    //読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲート・データソース
        commentTable.delegate = self
        commentTable.dataSource = self
        commentTable.tableFooterView = UIView()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 140
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentListCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = "\(dataArray[indexPath.row]["sender"] as! String)さんより"
        let comment = cell.viewWithTag(2) as! UITextView
        comment.text = dataArray[indexPath.row]["comment"] as? String
        comment.layer.cornerRadius = 10
        
        return cell
    }
}
