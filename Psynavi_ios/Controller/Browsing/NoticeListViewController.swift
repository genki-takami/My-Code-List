/*
 公開オブジェクトのお知らせ表示処理
 */

import UIKit

final class NoticeListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 変数
    var dataArray: [(noticeTitle:String?, date:Date?, noticeContent:String?, strDate:String?)] = []
    @IBOutlet weak var noticeTable: UITableView!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲート・データソース
        noticeTable.delegate = self
        noticeTable.dataSource = self
        noticeTable.tableFooterView = UIView()
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        noticeTable.reloadData()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 201
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "readingNoticeCell", for: indexPath)
        
        let name = cell.viewWithTag(1) as! UILabel
        name.text = dataArray[indexPath.row].noticeTitle
        let date = cell.viewWithTag(2) as! UILabel
        date.text = dataArray[indexPath.row].strDate
        let content = cell.viewWithTag(3) as! UITextView
        content.text = dataArray[indexPath.row].noticeContent
        
        return cell
    }
}
