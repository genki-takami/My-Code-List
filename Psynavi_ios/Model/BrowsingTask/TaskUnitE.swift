/*
 MainViewControllerの拡張
 */

import UIKit
import SafariServices

extension MainViewController {
    
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func setUpCommentName() {
        if let myName = DataProcessing.getUserData("commentName") {
            commentName.text = myName
        } else {
            commentName.text = "匿名"
        }
    }
    
    // データの更新
    @objc func refrefhing(){
        loadingFlag = true
        shopArray.removeAll()
        displayArray.removeAll()
        eventArray.removeAll()
        noticeArray.removeAll()
        data.removeAll()
        databaseProperty.removeAll()
        self.viewDidAppear(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
            // 終了
            self.scrollView.refreshControl?.endRefreshing()
        }
    }
    
    func showBrowser(_ link: String) {
        if link.isEmpty {
            DisplayPop.error("Webページが見つかりません")
        } else {
            guard let url = URL(string: link) else { return }
            present(SFSafariViewController(url: url), animated: true, completion: nil)
        }
    }
}
