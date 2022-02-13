/*
 編集オブジェクトのコンテンツリストの処理
 */

import UIKit
import RealmSwift
import SVProgressHUD
import Firebase

final class EditContentListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // 変数
    @IBOutlet weak var contentsTable: UITableView!
    var mailAdress, password: String!
    let realm = try! Realm()
    var contentsArray: [ShopDisplay]! = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲート・データソース
        contentsTable.delegate = self
        contentsTable.dataSource = self
        contentsTable.tableFooterView = UIView()
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // データベースからオブジェクトのコンテンツを持ってくる
        self.contentsArray.removeAll()
        for item in realm.objects(ShopDisplay.self).filter("mailAdress == '\(String(self.mailAdress))' AND password == '\(String(self.password))'") {
            self.contentsArray.append(item)
        }
        // tableをリロード
        contentsTable.reloadData()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentsArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 90
        
        let cell = contentsTable.dequeueReusableCell(withIdentifier: "ContentsCell", for: indexPath)
        
        let content = contentsArray[indexPath.row]
        let name = cell.viewWithTag(1) as! UILabel
        name.text = content.name
        let place = cell.viewWithTag(2) as! UILabel
        place.text = content.place
        let manager = cell.viewWithTag(3) as! UILabel
        manager.text = content.manager
        let tag = cell.viewWithTag(4) as! UILabel
        tag.text = content.tag
        
        return cell
    }
    
    // セルのタップ時の処理を返す
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "contentsCellSegue", sender: nil)
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
                    self.realm.delete(self.contentsArray[indexPath.row])
                }
                self.contentsArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch _ as NSError {
                Analytics.logEvent("error_ContentsTableViewController_tableView_editingStyle", parameters: [AnalyticsParameterItemName:"コンテンツリスト(編集)のセル削除の失敗" as String])
                SVProgressHUD.showError(withStatus: "削除に失敗しました")
            }
        }
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "contentsCellSegue":
            let contentsEditViewController:EditContentViewController = segue.destination as! EditContentViewController
            let indexPath = self.contentsTable.indexPathForSelectedRow
            contentsEditViewController.content = contentsArray[indexPath!.row]
        case "editASegue":
            let contentsEditViewController:EditContentViewController = segue.destination as! EditContentViewController
            let content = ShopDisplay()
            content.id = NSUUID().uuidString
            content.mailAdress = self.mailAdress
            content.password = self.password
            contentsEditViewController.content = content
        default:
            break
        }
    }
}
