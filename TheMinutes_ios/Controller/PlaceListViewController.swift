/*
 登録した会議場所の表示処理
 */

import UIKit
import RealmSwift

final class PlaceListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var placeTable: UITableView!
    weak var delegate: DataReturn?
    var folderId: String!
    var places: [Place] = []
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTable.delegate = self
        placeTable.dataSource = self
        
        // データを参照する
        places.removeAll()
        let data = DataProcessing.findAll(RealmModel.place) as! Results<Place>
        data.filter("folderId == %@", folderId!).forEach {
            places.append($0)
        }
        placeTable.reloadData()
    }
}

extension PlaceListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeListCell", for: indexPath)
        
        let place = cell.viewWithTag(1) as! UILabel
        place.text = places[indexPath.row].meetingPlace
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = places[indexPath.row].meetingPlace
        delegate?.returnData(text: data)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
