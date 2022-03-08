/*
 登録した出席者の表示処理
 */

import UIKit

final class AttendeeListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var attendeeTable: UITableView!
    weak var delegate: DataReturn2?
    var attendees = [Attendee]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendeeTable.delegate = self
        attendeeTable.dataSource = self
    }
}
