/*
 編集オブジェクトのイベントリストの処理
 */

import UIKit
import RealmSwift

final class EditEventListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var eventTable: UITableView!
    var mailAdress, password: String!
    var eventArray = [Event]()
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.tableFooterView = UIView()
    }
    
    // MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // イベントデータを参照する
        eventArray.removeAll()
        let data = (DataProcessing.findAll(RealmModel.event) as! Results<Event>)
                .filter("mailAdress == '\(String(mailAdress))' AND password == '\(String(password))'")
        data.forEach {
            eventArray.append($0)
        }
        
        eventTable.reloadData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "eventsCellSegue":
            let editEventVC = segue.destination as! EditEventViewController
            let indexPath = eventTable.indexPathForSelectedRow
            editEventVC.event = eventArray[indexPath!.row]
        case "editCSegue":
            let editEventVC = segue.destination as! EditEventViewController
            
            let event = Event()
            event.mailAdress = mailAdress
            event.password = password
            
            editEventVC.event = event
        default:
            break
        }
    }
}
