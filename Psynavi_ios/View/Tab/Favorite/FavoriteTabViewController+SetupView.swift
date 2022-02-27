/*
 FavoriteTabViewControllerの拡張
 */

import UIKit

extension FavoriteTabViewController {
    
    /// UITableViewをセットアップ
    func setupView() {
        favoriteList.separatorStyle = .none
        /// カスタムセルの登録する
        favoriteList.register(UINib(nibName: "FavoriteTabListViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
    }
}
