/*
 HomeTabViewControllerの拡張
 */

import UIKit

extension HomeTabViewController {
    
    /// UISearchView・UITableView・UIRefreshControlをセットアップ
    func setupView() {
        search.searchBarStyle = .minimal
        festivalList.separatorStyle = .none
        festivalList.refreshControl = UIRefreshControl()
        festivalList.refreshControl?.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        /// カスタムセルを登録
        festivalList.register(UINib(nibName: "HomeTabListViewCell", bundle: nil), forCellReuseIdentifier: "HomeCell")
        
        setDismissKeyboard()
    }
    
    @objc func refreshTableView(){
        refreshData()
    }
}
