/*
 登録した出席者の表示処理
 */

import RealmSwift

final class AttendeeListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var attendeeTable: UITableView!
    weak var delegate: DataReturn2?
    var folderId: String!
    var attendees = [Attendee]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendeeTable.delegate = self
        attendeeTable.dataSource = self
        
        /// データを参照する
        attendees.removeAll()
        let data = RealmTask.findAll(RealmModel.attendee) as! Results<Attendee>
        data.filter("folderId == %@", folderId!).forEach {
            attendees.append($0)
        }
        attendeeTable.reloadData()
    }
}
