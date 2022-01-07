/*
 登録した会議場所の表示処理
 */

import UIKit
import RealmSwift

class PlaceList: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 変数
    @IBOutlet weak var placeTable: UITableView!
    var delegate: DataReturn?
    let realm = try! Realm()
    var dataArray: Results<PlaceModel>!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲート
        placeTable.delegate = self
        placeTable.dataSource = self
        
        // データを参照する
        self.dataArray = realm.objects(PlaceModel.self)
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeListCell", for: indexPath)
        
        let place = cell.viewWithTag(1) as! UILabel
        place.text = self.dataArray[indexPath.row].meetingPlace
        
        return cell
    }
    
    // セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.dataArray[indexPath.row].meetingPlace
        delegate?.returnData(text: data)
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
