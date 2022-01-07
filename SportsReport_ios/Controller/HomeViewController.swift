/*
 レポートリストの表示処理
 */

import UIKit
import RealmSwift
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 変数
    @IBOutlet weak var reportTable: UITableView!
    let realm = try! Realm()
    var dataArray: [Database] = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()

        // SVProgressHUDのセットアップ
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        // デリゲート・データソース
        reportTable.delegate = self
        reportTable.dataSource = self
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // オブジェクトを参照する
        dataArray.removeAll()
        for i in realm.objects(Database.self).sorted(byKeyPath: "date", ascending: false){
            dataArray.append(i)
        }
        reportTable.reloadData()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さ
        tableView.rowHeight = 100
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath)
        
        let injured = cell.viewWithTag(1) as! UILabel
        injured.text = dataArray[indexPath.row].injured
        let reporter = cell.viewWithTag(2) as! UILabel
        reporter.text = "報告者：" + dataArray[indexPath.row].reporter
        let date = cell.viewWithTag(3) as! UILabel
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString:String = formatter.string(from: dataArray[indexPath.row].date)
        date.text = dateString
        let diagnosis = cell.viewWithTag(4) as! UILabel
        diagnosis.text = dataArray[indexPath.row].diagnosis
        let image = cell.viewWithTag(5) as! UIImageView
        image.image = UIImage(data: dataArray[indexPath.row].image)
        
        return cell
    }
    
    // 各セルを選択した時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "eds", sender: nil)
    }
    
    // セルは削除可能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // 削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            // データベースから削除
            do {
                try realm.write{
                    self.realm.delete(self.dataArray[indexPath.row])
                }
                self.dataArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch _ as NSError {
                SVProgressHUD.showError(withStatus: "削除失敗！再度お試しください")
            }
        }
    }
    
    // 遷移時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "eds"{
            let inputViewController:InputViewController = segue.destination as! InputViewController
            let indexPath = self.reportTable.indexPathForSelectedRow
            inputViewController.reportData = self.dataArray[indexPath!.row]
        } else if segue.identifier == "ans" {
            let inputViewController:InputViewController = segue.destination as! InputViewController
            let newReport = Database()
            let allReports = realm.objects(Database.self)
            if allReports.count != 0{
                newReport.id = allReports.max(ofProperty: "id")! + 1
            }
            inputViewController.reportData = newReport
        }
    }
    
    // 新規追加
    @IBAction func addNew(_ sender: Any) {
        performSegue(withIdentifier: "ans", sender: nil)
    }
}
