/*
 公開オブジェクトのショップリスト表示の処理
 */

import UIKit

final class ShopListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // 変数
    var dataArray: [[String : Any]] = []
    @IBOutlet weak var shopTable: UITableView!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // デリゲート・データソース
        shopTable.delegate = self
        shopTable.dataSource = self
        shopTable.tableFooterView = UIView()
    }
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        shopTable.reloadData()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 125
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "readingShopCell", for: indexPath)
        
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
        performSegue(withIdentifier: "shopDetailsCellSegue",sender: nil)
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shopDetailsCellSegue"{
            let readingShopContentViewController:ShopViewController = segue.destination as! ShopViewController
            let indexPath = self.shopTable.indexPathForSelectedRow
            readingShopContentViewController.uuid = dataArray[indexPath!.row]["id"] as? String
            readingShopContentViewController.name = dataArray[indexPath!.row]["name"] as? String
            readingShopContentViewController.date = dataArray[indexPath!.row]["date"] as? String
            readingShopContentViewController.place = dataArray[indexPath!.row]["place"] as? String
            readingShopContentViewController.manager = dataArray[indexPath!.row]["manager"] as? String
            readingShopContentViewController.managerInfo = dataArray[indexPath!.row]["managerInfo"] as? String
            readingShopContentViewController.tag = dataArray[indexPath!.row]["tag"] as? String
            readingShopContentViewController.info = dataArray[indexPath!.row]["info"] as? String
            readingShopContentViewController.video = dataArray[indexPath!.row]["video"] as? Bool
        }
    }
}
