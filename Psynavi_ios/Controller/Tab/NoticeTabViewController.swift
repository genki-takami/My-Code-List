/*
 お知らせタブの処理
 */

import UIKit
import RealmSwift

final class NoticeTabViewController: UIViewController {

    // MARK: - Property
    @IBOutlet weak var noticeList: UITableView!
    var notices = [NoticeParam]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpTableView()
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notices.removeAll()
        let favorites = DataProcessing.findAll(RealmModel.favorite) as! Results<Favorite>
        
        if favorites.count > 0 {
            receiveNotices(favorites)
        } else {
            noticeList.reloadData()
        }
    }
    
    private func setUpTableView() {
        noticeList.delegate = self
        noticeList.dataSource = self
        noticeList.tableFooterView = UIView()
        noticeList.refreshControl = UIRefreshControl()
        noticeList.refreshControl?.addTarget(self, action: #selector(refreshNotices), for: .valueChanged)
    }
    
    // MARK: - お知らせを受信する
    private func receiveNotices(_ favorites: Results<Favorite>) {
        
        var taskCounter = favorites.count
        DisplayPop.show()
        
        for favorite in favorites {
            // お気に入り登録されたコンテンツのお知らせデータを受信
            FetchData.fetchDocument(PathName.ListNoticeID, favorite.id) { result in
                switch result {
                case .success(let data):
                    let task = self.makeData(data, favorite.festivalName)
                    taskCounter -= task
                    self.checkTask(taskCounter)
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                    // すでに削除されているorエラー
                    taskCounter -= 1
                    self.checkTask(taskCounter)
                }
            }
        }
    }
}
