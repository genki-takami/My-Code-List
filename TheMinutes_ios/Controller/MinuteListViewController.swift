/*
 議事録ファイルリストの処理
 */

import UIKit
import RealmSwift

final class MinuteListViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var headerTitile: UILabel!
    @IBOutlet private weak var minuteList: UITableView!
    var folderId: String!
    var titleName: String!
    var minutes: [Minute] = []
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイトルを変更する
        headerTitile.text = titleName
        
        minuteList.delegate = self
        minuteList.dataSource = self
    }
    
    // MARK: - VIEWWILLAPPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 議事録を参照する
        minutes.removeAll()
        let data = DataProcessing.findAll(RealmModel.minute) as! Results<Minute>
        let sortedData = data.filter("folderId == %@", folderId!).sorted(byKeyPath: "date", ascending: false)
        sortedData.forEach {
            minutes.append($0)
        }
        minuteList.reloadData()
    }
    
    // MARK: - PREPARE FOR SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let minuteAddVC: MinuteAddViewController
        let registerAddVC: ResisterAddViewController
        
        if segue.identifier == "minuteEditSegue" {
            minuteAddVC = segue.destination as! MinuteAddViewController
            let indexPath = minuteList.indexPathForSelectedRow
            minuteAddVC.minute = minutes[indexPath!.row]
            minuteAddVC.isNewObject = false
        } else if segue.identifier == "minuteAddSegue" {
            minuteAddVC = segue.destination as! MinuteAddViewController
            let newMinute = Minute()
            newMinute.folderId = folderId
            minuteAddVC.minute = newMinute
            minuteAddVC.isNewObject = true
        } else if segue.identifier == "registerSegue" {
            registerAddVC = segue.destination as! ResisterAddViewController
            registerAddVC.folderId = folderId
        }
    }
}
