/*
 公開オブジェクトのディスプレイリスト表示の処理
 */

import UIKit

final class DisplayListViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var displayTable: UITableView!
    var displays = [[String : Any]]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        displayTable.delegate = self
        displayTable.dataSource = self
        displayTable.tableFooterView = UIView()
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        displayTable.reloadData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "displayDetailsCellSegue" {
            let displayVC = segue.destination as! DisplayViewController
            let indexPath = displayTable.indexPathForSelectedRow
            displayVC.uuid = displays[indexPath!.row]["id"] as? String
            displayVC.name = displays[indexPath!.row]["name"] as? String
            displayVC.date = displays[indexPath!.row]["date"] as? String
            displayVC.place = displays[indexPath!.row]["place"] as? String
            displayVC.manager = displays[indexPath!.row]["manager"] as? String
            displayVC.managerInfo = displays[indexPath!.row]["managerInfo"] as? String
            displayVC.tag = displays[indexPath!.row]["tag"] as? String
            displayVC.info = displays[indexPath!.row]["info"] as? String
            displayVC.video = displays[indexPath!.row]["video"] as? Bool
        }
    }
}
