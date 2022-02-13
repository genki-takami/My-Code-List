/*
 編集オブジェクトのお知らせリストの処理
 */

import UIKit
import RealmSwift

final class EditNoticeListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var noticeTable: UITableView!
    var mailAdress, password: String!
    var noticeArray = [Notices]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noticeTable.delegate = self
        noticeTable.dataSource = self
        noticeTable.tableFooterView = UIView()
    }
    
    // MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // お知らせデータを参照
        noticeArray.removeAll()
        let data = (DataProcessing.findAll(RealmModel.notice) as! Results<Notices>)
                        .filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        data.forEach {
            noticeArray.append($0)
        }
        
        noticeTable.reloadData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "noticeCellSegue":
            let editNoticeVC = segue.destination as! EditNoticeViewController
            let indexPath = noticeTable.indexPathForSelectedRow
            editNoticeVC.notice = noticeArray[indexPath!.row]
        case "editBSegue":
            let editNoticeVC = segue.destination as! EditNoticeViewController
            
            let notice = Notices()
            notice.mailAdress = mailAdress
            notice.password = password
            
            editNoticeVC.notice = notice
        default:
            break
        }
    }
}
