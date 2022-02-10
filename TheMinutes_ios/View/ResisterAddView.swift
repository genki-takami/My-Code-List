/*
 ResisterAddViewControllerの拡張
 */

import UIKit

extension ResisterAddViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var cellCount = 0
        
        if tableView.isEqual(attendeeList) {
            cellCount = attendees.count
        } else if tableView.isEqual(placeList) {
            cellCount = places.count
        }
        
        return cellCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: getCellIdentifier(tableView), for:indexPath as IndexPath)
        
        if tableView.isEqual(attendeeList) {
            cell.textLabel?.text = attendees[indexPath.row].attendeeName
        } else if tableView.isEqual(placeList) {
            cell.textLabel?.text = places[indexPath.row].meetingPlace
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // データベースから削除する
        if editingStyle == .delete {
            if tableView.isEqual(attendeeList) {
                DataProcessing.delete(attendees[indexPath.row], RealmModel.attendee) { result in
                    switch result {
                    case .success(let text):
                        DisplayPop.success(text)
                        self.attendees.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(let error):
                        DisplayPop.error(error.localizedDescription)
                    }
                }
            } else if tableView.isEqual(placeList) {
                DataProcessing.delete(places[indexPath.row], RealmModel.place) { result in
                    switch result {
                    case .success(let text):
                        DisplayPop.success(text)
                        self.places.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    case .failure(let error):
                        DisplayPop.error(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // セルの識別
    private func getCellIdentifier(_ tableView: UITableView) -> String {
        
        var cellIdentifier = ""
        
        if tableView.isEqual(attendeeList) {
            cellIdentifier = "attendeeCell"
        } else if tableView.isEqual(placeList) {
            cellIdentifier = "placeCell"
        }
        
        return cellIdentifier
    }
}
