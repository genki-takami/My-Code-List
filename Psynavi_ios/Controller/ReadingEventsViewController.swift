/*
 公開オブジェクトのイベントリスト表示の処理
 */

import UIKit

class ReadingEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 変数
    var dataArray: [[String : Any]] = []
    @IBOutlet weak var eventsTable: UITableView!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲート・データソース
        eventsTable.delegate = self
        eventsTable.dataSource = self
        eventsTable.tableFooterView = UIView()
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventsTable.reloadData()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 67
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "readingEventsCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = dataArray[indexPath.row]["eventTitle"] as? String
        let date = cell.viewWithTag(2) as! UILabel
        date.text = dataArray[indexPath.row]["eventDate"] as? String
        
        return cell
    }
    
    // セルが選択された時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eventDetailsCellSegue", sender: nil)
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetailsCellSegue"{
            let readingEventsContentViewController:ReadingEventsContentViewController = segue.destination as! ReadingEventsContentViewController
            let indexPath = self.eventsTable.indexPathForSelectedRow
            readingEventsContentViewController.uuid = dataArray[indexPath!.row]["id"] as? String
            readingEventsContentViewController.eventTitle = dataArray[indexPath!.row]["eventTitle"] as? String
            readingEventsContentViewController.eventDate = dataArray[indexPath!.row]["eventDate"] as? String
            readingEventsContentViewController.caption = dataArray[indexPath!.row]["caption"] as? String
            readingEventsContentViewController.imageCaptions = dataArray[indexPath!.row]["imageCaptions"] as? [String]
            readingEventsContentViewController.video = dataArray[indexPath!.row]["video"] as? Bool
        }
    }
}
