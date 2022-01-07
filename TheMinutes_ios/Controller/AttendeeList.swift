/*
 登録した出席者の表示処理
 */

import UIKit
import RealmSwift

class AttendeeList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 変数
    @IBOutlet weak var attendeeTable: UITableView!
    var delegate: DataReturn2?
    let realm = try! Realm()
    var dataArray: Results<AttendeeModel>!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲート
        attendeeTable.delegate = self
        attendeeTable.dataSource = self
        
        // データを参照する
        self.dataArray = realm.objects(AttendeeModel.self)
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "attendeeListCell", for: indexPath)
        
        let attendee = cell.viewWithTag(1) as! UILabel
        attendee.text = self.dataArray[indexPath.row].attendeeName
        
        return cell
    }
    
    // セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.dataArray[indexPath.row].attendeeName
        delegate?.returnData2(text: data)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
