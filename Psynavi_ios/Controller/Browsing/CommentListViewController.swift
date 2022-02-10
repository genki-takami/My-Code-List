/*
 コメントリストの処理
 */

import UIKit

final class CommentListViewController: UIViewController {

    // MARK: - Property
    var comments = [[String:Any]]()
    @IBOutlet private weak var commentTable: UITableView!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        commentTable.delegate = self
        commentTable.dataSource = self
        commentTable.tableFooterView = UIView()
    }
}
