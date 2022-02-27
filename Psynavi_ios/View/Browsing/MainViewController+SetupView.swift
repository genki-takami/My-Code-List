/*
 MainViewControllerの拡張
 */

import UIKit

extension MainViewController {
    
    /// UIのセットアップ
    func setupView() {
        
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        setupCommentName()
        setDismissKeyboard()
    }
    
    /// データの更新
    @objc func refreshData(){
        isFirstFetch = true
        shops.removeAll()
        displays.removeAll()
        events.removeAll()
        notices.removeAll()
        maps.removeAll()
        databaseProperty.removeAll()
        self.viewDidAppear(true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    /// コメントネームをUILabelに反映
    private func setupCommentName() {
        if let myName = UserDefaultsTask.getUserData("commentName") {
            commentName.text = myName
        } else {
            commentName.text = "匿名"
        }
    }
}
