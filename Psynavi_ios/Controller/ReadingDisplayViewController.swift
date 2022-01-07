/*
 公開オブジェクトのディスプレイリスト表示の処理
 */

import UIKit

class ReadingDisplayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 変数
    var dataArray: [[String : Any]] = []
    @IBOutlet weak var displayTable: UITableView!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲート・データソース
        displayTable.delegate = self
        displayTable.dataSource = self
        displayTable.tableFooterView = UIView()
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayTable.reloadData()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 125
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "readingDisplayCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = dataArray[indexPath.row]["name"] as? String
        let place = cell.viewWithTag(2) as! UILabel
        place.text = dataArray[indexPath.row]["place"] as? String
        let manager = cell.viewWithTag(3) as! UILabel
        manager.text = dataArray[indexPath.row]["manager"] as? String
        let tag = cell.viewWithTag(4) as! UILabel
        tag.text = dataArray[indexPath.row]["tag"] as? String
        
        return cell
    }
    
    // セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "displayDetailsCellSegue",sender: nil)
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayDetailsCellSegue"{
            let readingDisplayContentViewController:ReadingDisplayContentViewController = segue.destination as! ReadingDisplayContentViewController
            let indexPath = self.displayTable.indexPathForSelectedRow
            readingDisplayContentViewController.uuid = dataArray[indexPath!.row]["id"] as? String
            readingDisplayContentViewController.name = dataArray[indexPath!.row]["name"] as? String
            readingDisplayContentViewController.date = dataArray[indexPath!.row]["date"] as? String
            readingDisplayContentViewController.place = dataArray[indexPath!.row]["place"] as? String
            readingDisplayContentViewController.manager = dataArray[indexPath!.row]["manager"] as? String
            readingDisplayContentViewController.managerInfo = dataArray[indexPath!.row]["managerInfo"] as? String
            readingDisplayContentViewController.tag = dataArray[indexPath!.row]["tag"] as? String
            readingDisplayContentViewController.info = dataArray[indexPath!.row]["info"] as? String
            readingDisplayContentViewController.video = dataArray[indexPath!.row]["video"] as? Bool
        }
    }
}
