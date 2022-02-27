/*
 公開オブジェクトのイベントリスト表示の処理
 */

import UIKit

final class EventListViewController: UIViewController {
    
    // MARK: - Property
    @IBOutlet private weak var eventsTable: UITableView!
    var events = [[String : Any]]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()

        eventsTable.delegate = self
        eventsTable.dataSource = self
        eventsTable.tableFooterView = UIView()
    }
    
    // MARK: - VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        eventsTable.reloadData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "eventDetailsCellSegue" {
            let eventVC = segue.destination as! EventViewController
            let indexPath = self.eventsTable.indexPathForSelectedRow
            eventVC.uuid = events[indexPath!.row]["id"] as? String
            eventVC.eventTitle = events[indexPath!.row]["eventTitle"] as? String
            eventVC.eventDate = events[indexPath!.row]["eventDate"] as? String
            eventVC.caption = events[indexPath!.row]["caption"] as? String
            eventVC.imageCaptions = events[indexPath!.row]["imageCaptions"] as? [String]
            eventVC.video = events[indexPath!.row]["video"] as? Bool
        }
    }
}
