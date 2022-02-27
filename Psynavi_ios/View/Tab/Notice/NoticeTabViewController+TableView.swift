/*
 NoticeTabViewControllerの拡張
 */

import UIKit

extension NoticeTabViewController: UITableViewDelegate, UIViewControllerTransitioningDelegate {
    
    /// セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// お知らせ詳細ポップを表示する
        let noticePopupViewController = self.storyboard?.instantiateViewController(withIdentifier: "noticePopup") as! NoticePopupViewController
        noticePopupViewController.modalPresentationStyle = .custom
        noticePopupViewController.transitioningDelegate = self
        noticePopupViewController.fesName = notices[indexPath.row].name
        noticePopupViewController.noticeTitle = notices[indexPath.row].noticeTitle
        noticePopupViewController.noticeDate = notices[indexPath.row].strDate
        noticePopupViewController.noticeContent = notices[indexPath.row].noticeContent
        
        present(noticePopupViewController, animated: true, completion: nil)
    }
    
    /// UITableを更新
    func reloadTable() {
        noticeList.reloadData()
    }
}

extension NoticeTabViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notices.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// セルの高さ
        tableView.rowHeight = 99
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "noticeBarCell", for: indexPath)
       
        let festivalName = cell.viewWithTag(1) as! UILabel
        festivalName.text = notices[indexPath.row].name
        let noticeTitle = cell.viewWithTag(2) as! UILabel
        let mainSentence = notices[indexPath.row].noticeTitle
        noticeTitle.text = "件名：\(String(mainSentence!))"
        let noticeDate = cell.viewWithTag(3) as! UILabel
        noticeDate.text = notices[indexPath.row].strDate
        
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    @objc func goToDetail(sender: MyTapGestureRecognizer) {
        tableView(noticeList, didSelectRowAt: sender.indexValue!)
    }
}
