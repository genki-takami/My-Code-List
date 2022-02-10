/*
 登録した出席者の表示処理
 */

import UIKit
import RealmSwift

final class AttendeeListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var attendeeTable: UITableView!
    weak var delegate: DataReturn2?
    var folderId: String!
    var attendees: [Attendee] = []
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendeeTable.delegate = self
        attendeeTable.dataSource = self
        
        // データを参照する
        attendees.removeAll()
        let data = DataProcessing.findAll(RealmModel.attendee) as! Results<Attendee>
        data.filter("folderId == %@", folderId!).forEach {
            attendees.append($0)
        }
        attendeeTable.reloadData()
    }
}

extension AttendeeListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendeeListCell", for: indexPath)
        
        let attendee = cell.viewWithTag(1) as! UILabel
        attendee.text = attendees[indexPath.row].attendeeName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = attendees[indexPath.row].attendeeName
        delegate?.returnData2(text: data)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
