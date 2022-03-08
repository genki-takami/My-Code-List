/*
 登録した会議場所の表示処理
 */

import UIKit

final class PlaceListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var placeTable: UITableView!
    weak var delegate: DataReturn?
    var places = [Place]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeTable.delegate = self
        placeTable.dataSource = self
    }
}
