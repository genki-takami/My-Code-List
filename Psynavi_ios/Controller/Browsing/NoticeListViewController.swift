/*
 公開オブジェクトのお知らせ表示処理
 */

import UIKit

final class NoticeListViewController: UIViewController {
    
    // MARK: - Property
    var notices = [NoticeParam]()
    @IBOutlet private weak var noticeTable: UITableView!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        noticeTable.delegate = self
        noticeTable.dataSource = self
        noticeTable.tableFooterView = UIView()
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        noticeTable.reloadData()
    }
}
