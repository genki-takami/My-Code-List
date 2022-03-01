/*
 登録した会議場所の表示処理
 */

import RealmSwift

final class PlaceListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var placeTable: UITableView!
    weak var delegate: DataReturn?
    var folderId: String!
    var places = [Place]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTable.delegate = self
        placeTable.dataSource = self
        
        /// データを参照する
        places.removeAll()
        let data = RealmTask.findAll(RealmModel.place) as! Results<Place>
        data.filter("folderId == %@", folderId!).forEach {
            places.append($0)
        }
        placeTable.reloadData()
    }
}
