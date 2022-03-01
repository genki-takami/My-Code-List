/*
 AttendeeListViewControllerの拡張
 */

import UIKit

extension AttendeeListViewController: UITableViewDelegate {
    
    /// セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = attendees[indexPath.row].attendeeName
        delegate?.returnData2(text: data)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension AttendeeListViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attendees.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendeeListCell", for: indexPath)
        
        let attendee = cell.viewWithTag(1) as! UILabel
        attendee.text = attendees[indexPath.row].attendeeName
        
        return cell
    }
}
