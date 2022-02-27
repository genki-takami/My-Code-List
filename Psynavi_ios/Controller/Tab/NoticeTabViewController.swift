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
        
        noticeList.delegate = self
        noticeList.dataSource = self
        
        setupView()
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        notices.removeAll()
        let favorites = RealmTask.findAll(RealmModel.favorite) as! Results<Favorite>
        
        if favorites.count > 0 {
            receiveNotices(favorites)
        } else {
            reloadTable()
        }
    }
}
