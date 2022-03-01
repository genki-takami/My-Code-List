/*
 PlaceListViewControllerの拡張
 */

import UIKit

extension PlaceListViewController: UITableViewDelegate {
    
    /// セルをタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = places[indexPath.row].meetingPlace
        delegate?.returnData(text: data)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension PlaceListViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeListCell", for: indexPath)
        
        let place = cell.viewWithTag(1) as! UILabel
        place.text = places[indexPath.row].meetingPlace
        
        return cell
    }
}
