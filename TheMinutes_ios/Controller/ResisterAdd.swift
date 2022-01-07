/*
 出席者と会議場所の追加処理
 */

import UIKit
import RealmSwift
import SVProgressHUD

class ResisterAdd: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 変数
    @IBOutlet weak var attendeeList: UITableView!
    @IBOutlet weak var attendeeInput: UITextField!
    @IBOutlet weak var placeList: UITableView!
    @IBOutlet weak var placeInput: UITextField!
    let realm = try! Realm()
    var placeDataArray: [PlaceModel] = []
    var attendeeDataArray: [AttendeeModel] = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲート・データソース
        attendeeList.dataSource = self
        attendeeList.delegate = self
        placeList.dataSource = self
        placeList.delegate = self
        
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // データを参照
        placeDataArray.removeAll()
        for place in realm.objects(PlaceModel.self){
            self.placeDataArray.append(place)
        }
        placeList.reloadData()
        attendeeDataArray.removeAll()
        for attendee in realm.objects(AttendeeModel.self){
            self.attendeeDataArray.append(attendee)
        }
        attendeeList.reloadData()
    }
    
    // 出席者登録
    @IBAction func attendeeAdd(_ sender: Any) {
        if let text = attendeeInput.text{
            
            if text.isEmpty{
                SVProgressHUD.showError(withStatus: "追加したい出席者の名前を入力してください")
                return
            }
            
            let setAttendee = AttendeeModel()
            let attendees = realm.objects(AttendeeModel.self)
            if attendees.count != 0{
                setAttendee.id = attendees.max(ofProperty: "id")! + 1
            }
            do {
                try realm.write {
                    setAttendee.attendeeName = text
                    self.realm.add(setAttendee, update: .modified)
                }
                attendeeInput.text = ""
                self.attendeeDataArray.append(setAttendee)
                SVProgressHUD.showSuccess(withStatus: "登録完了！")
                self.attendeeList.reloadData()
            } catch _ as NSError {
                SVProgressHUD.showError(withStatus: "登録に失敗！再度お試しください")
            }
            
        }
    }
    
    // 会議場所登録
    @IBAction func placeAdd(_ sender: Any) {
        if let text = placeInput.text{
            
            if text.isEmpty{
                SVProgressHUD.showError(withStatus: "場所の名前を入力してください")
                return
            }
            
            let setPlace = PlaceModel()
            let places = realm.objects(PlaceModel.self)
            if places.count != 0{
                setPlace.id = places.max(ofProperty: "id")! + 1
            }
            do {
                try realm.write {
                    setPlace.meetingPlace = text
                    self.realm.add(setPlace, update: .modified)
                }
                placeInput.text = ""
                self.placeDataArray.append(setPlace)
                SVProgressHUD.showSuccess(withStatus: "登録完了！")
                self.placeList.reloadData()
            } catch _ as NSError {
                SVProgressHUD.showError(withStatus: "登録に失敗！再度お試しください")
            }
        }
    }
    
    // セルの識別
    func checkTableView(_ tableView: UITableView) -> String {
        var cellIdentifier = ""
        
        if tableView.isEqual(attendeeList) {
            cellIdentifier = "attendeeCell"
        } else if tableView.isEqual(placeList) {
            cellIdentifier = "placeCell"
        }
        
        return cellIdentifier
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellCount = 0
        
        if tableView.isEqual(attendeeList) {
            cellCount = self.attendeeDataArray.count
        } else if tableView.isEqual(placeList) {
            cellCount = self.placeDataArray.count
        }
        
        return cellCount
    }

    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = checkTableView(tableView)
        let cell = tableView.dequeueReusableCell(withIdentifier:cellIdentifier, for:indexPath as IndexPath)
        
        if tableView.isEqual(attendeeList) {
            cell.textLabel?.text = self.attendeeDataArray[indexPath.row].attendeeName
        } else if tableView.isEqual(placeList) {
            cell.textLabel?.text = self.placeDataArray[indexPath.row].meetingPlace
        }
        
        return cell
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
                    if tableView.isEqual(attendeeList) {
                        self.realm.delete(self.attendeeDataArray[indexPath.row])
                        self.attendeeDataArray.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    } else if tableView.isEqual(placeList) {
                        self.realm.delete(self.placeDataArray[indexPath.row])
                        self.placeDataArray.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            } catch _ as NSError {
                SVProgressHUD.showError(withStatus: "削除に失敗！再度お試しください")
            }
        }
    }
}
