/*
 編集オブジェクトのイベントリストの処理
 */

import UIKit
import RealmSwift
import Firebase
import SVProgressHUD

final class EditEventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 変数
    @IBOutlet weak var eventTable: UITableView!
    var mailAdress, password: String!
    let realm = try! Realm()
    var eventArray: [EventsDB]! = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲート・データソース
        eventTable.delegate = self
        eventTable.dataSource = self
        eventTable.tableFooterView = UIView()
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // データベースからオブジェクトのイベントを持ってくる
        self.eventArray.removeAll()
        for item in realm.objects(EventsDB.self).filter("mailAdress == '\(String(self.mailAdress))' AND password == '\(String(self.password))'") {
            self.eventArray.append(item)
        }
        eventTable.reloadData()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 56
        
        let cell = eventTable.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let event = eventArray[indexPath.row]
        
        cell.textLabel?.text = event.eventTitle
        cell.detailTextLabel?.text = event.eventDate
        
        return cell
    }
    
    // セルのタップ時の処理を返す
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventsCellSegue", sender: nil)
    }
    
    // セルに削除可能か返す
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    // Deleteボタン
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する
            do {
                try realm.write {
                    self.realm.delete(self.eventArray[indexPath.row])
                }
                self.eventArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch _ as NSError {
                Analytics.logEvent("error_EventsTableViewController_tableView_editingStyle", parameters: [AnalyticsParameterItemName:"イベントリスト(編集)のセルの削除に失敗" as String])
                SVProgressHUD.showError(withStatus: "削除できませんでした")
            }
        }
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        switch segue.identifier {
        case "eventsCellSegue":
            let eventsEditViewController:EditEventViewController = segue.destination as! EditEventViewController
            let indexPath = self.eventTable.indexPathForSelectedRow
            eventsEditViewController.event = eventArray[indexPath!.row]
        case "editCSegue":
            let eventsEditViewController:EditEventViewController = segue.destination as! EditEventViewController
            let event = EventsDB()
            event.id = NSUUID().uuidString
            event.mailAdress = self.mailAdress
            event.password = self.password
            eventsEditViewController.event = event
        default:
            break
        }
    }
}
