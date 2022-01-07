/*
 議事録ファイルリストの処理
 */

import UIKit
import RealmSwift
import SVProgressHUD

class MinuteList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 変数
    @IBOutlet weak var headerTitile: UILabel!
    @IBOutlet weak var minuteList: UITableView!
    var folderId:Int!
    var titleName: String!
    let realm = try! Realm()
    var minuteArray: [MinuteListModel] = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイトルを変更する
        self.headerTitile.text = titleName
        
        // デリゲート・データソース
        minuteList.delegate = self
        minuteList.dataSource = self
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // データを読み込む
        self.minuteArray.removeAll()
        for i in realm.objects(MinuteListModel.self).filter("folderId == %@",Int(folderId)).sorted(byKeyPath: "date", ascending: false){
            self.minuteArray.append(i)
        }
        minuteList.reloadData()
    }
    
    // セルの数のを返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return minuteArray.count
    }

    // 各セルの中身を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "minuteCell", for: indexPath)
        
        cell.textLabel?.text = minuteArray[indexPath.row].meetingName
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: minuteArray[indexPath.row].date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }

    // 各セルを選択した時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "minuteEditSegue",sender: nil)
    }

    // セルは削除可能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    // 削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する
            do {
                try realm.write {
                    self.realm.delete(self.minuteArray[indexPath.row])
                }
                self.minuteArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch _ as NSError {
                SVProgressHUD.showError(withStatus: "削除に失敗！再度お試しください")
            }
        }
    }
    
    // 遷移時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "minuteEditSegue"{
            let minuteadd:MinuteAdd = segue.destination as! MinuteAdd
            let indexPath = self.minuteList.indexPathForSelectedRow
            minuteadd.minute = self.minuteArray[indexPath!.row]
            minuteadd.isNewObject = false
        } else if segue.identifier == "minuteAddSegue"{
            let minuteadd:MinuteAdd = segue.destination as! MinuteAdd
            let newMinute = MinuteListModel()
            let allMinutes = realm.objects(MinuteListModel.self)
            if allMinutes.count != 0{
                newMinute.id = allMinutes.max(ofProperty: "id")! + 1
            }
            newMinute.folderId = self.folderId
            minuteadd.minute = newMinute
            minuteadd.isNewObject = true
        }
    }
}
