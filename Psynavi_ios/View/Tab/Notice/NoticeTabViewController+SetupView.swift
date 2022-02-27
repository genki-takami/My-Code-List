/*
 NoticeTabViewControllerの拡張
 */

import UIKit

extension NoticeTabViewController {
    
    /// UITableViewのセットアップ
    func setupView() {
        noticeList.tableFooterView = UIView()
        noticeList.refreshControl = UIRefreshControl()
        noticeList.refreshControl?.addTarget(self, action: #selector(refreshNotices), for: .valueChanged)
    }
    
    @objc func refreshNotices() {
        self.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.noticeList.refreshControl?.endRefreshing()
        }
    }
    
    /// カスタムポップアップを表示
    func presentationController(forPresented presented: UIViewController,
                                presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting)
    }
}
