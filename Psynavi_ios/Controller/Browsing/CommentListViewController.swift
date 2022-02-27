/*
 コメントリストの処理
 */

import UIKit

final class CommentListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var commentTable: UITableView!
    var comments = [[String:Any]]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTable.delegate = self
        commentTable.dataSource = self
        commentTable.tableFooterView = UIView()
    }
}
