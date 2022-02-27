/*
 公開オブジェクトのショップリスト表示の処理
 */

import UIKit

final class ShopListViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var shopTable: UITableView!
    var shops = [[String:Any]]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        shopTable.delegate = self
        shopTable.dataSource = self
        shopTable.tableFooterView = UIView()
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        shopTable.reloadData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "shopDetailsCellSegue" {
            let shopVC = segue.destination as! ShopViewController
            let indexPath = shopTable.indexPathForSelectedRow
            shopVC.uuid = shops[indexPath!.row]["id"] as? String
            shopVC.name = shops[indexPath!.row]["name"] as? String
            shopVC.date = shops[indexPath!.row]["date"] as? String
            shopVC.place = shops[indexPath!.row]["place"] as? String
            shopVC.manager = shops[indexPath!.row]["manager"] as? String
            shopVC.managerInfo = shops[indexPath!.row]["managerInfo"] as? String
            shopVC.tag = shops[indexPath!.row]["tag"] as? String
            shopVC.info = shops[indexPath!.row]["info"] as? String
            shopVC.video = shops[indexPath!.row]["video"] as? Bool
        }
    }
}
