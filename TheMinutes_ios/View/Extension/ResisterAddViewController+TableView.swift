/*
 ResisterAddViewControllerの拡張
 */

import UIKit

extension ResisterAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.isEqual(attendeeList) {
            return attendees.count
        } else if tableView.isEqual(placeList) {
            return places.count
        } else {
            fatalError()
        }
    }

    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: setCellIdentifier(tableView), for:indexPath as IndexPath)
        
        if tableView.isEqual(attendeeList) {
            cell.textLabel?.text = attendees[indexPath.row].attendeeName
        } else if tableView.isEqual(placeList) {
            cell.textLabel?.text = places[indexPath.row].meetingPlace
        }
        
        return cell
    }
    
    /// セルの識別
    private func setCellIdentifier(_ tableView: UITableView) -> String {
        
        if tableView.isEqual(attendeeList) {
            return "attendeeCell"
        } else if tableView.isEqual(placeList) {
            return "placeCell"
        } else {
            fatalError()
        }
    }

    /// セルは削除可能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    /// データベースから削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if tableView.isEqual(attendeeList) {
                
                RealmTask.delete(attendees[indexPath.row], RealmModel.attendee) { result in
                    switch result {
                    case .success(let text):
                        Modal.showSuccess(text)
                        self.attendees.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(let error):
                        Modal.showError(String(describing: error))
                    }
                }
            } else if tableView.isEqual(placeList) {
                
                RealmTask.delete(places[indexPath.row], RealmModel.place) { result in
                    switch result {
                    case .success(let text):
                        Modal.showSuccess(text)
                        self.places.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(let error):
                        Modal.showError(String(describing: error))
                    }
                }
            }
        }
    }
}
