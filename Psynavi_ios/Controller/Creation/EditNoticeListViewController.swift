/*
 編集オブジェクトのお知らせリストの処理
 */

import UIKit
import RealmSwift
import SVProgressHUD
import Firebase

final class EditNoticeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // 変数
    @IBOutlet weak var noticeTable: UITableView!
    var mailAdress, password: String!
    let realm = try! Realm()
    var noticeArray: [Notices]! = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲート・データソース
        noticeTable.delegate = self
        noticeTable.dataSource = self
        noticeTable.tableFooterView = UIView()
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // データベースからオブジェクトのお知らせを持ってくる
        self.noticeArray.removeAll()
        for item in realm.objects(Notices.self).filter("mailAdress == '\(String(self.mailAdress))' AND password == '\(String(self.password))'") {
            self.noticeArray.append(item)
        }
        // tableをリロード
        noticeTable.reloadData()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noticeArray.count
    }
    
    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 56
        
        let cell = noticeTable.dequeueReusableCell(withIdentifier: "noticeCell", for: indexPath)
        let notice = noticeArray[indexPath.row]
        
        // 日付のフォーマットを変更
        let f = DateFormatter()
        f.locale = Locale(identifier: "ja_JP")
        f.dateStyle = .long
        f.timeStyle = .short
        let date = f.string(from: notice.date)
        
        cell.textLabel?.text = notice.noticeTitle
        cell.detailTextLabel?.text = date
        
        return cell
    }
    
    // セルのタップ時の処理を返す
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "noticeCellSegue", sender: nil)
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
                    self.realm.delete(self.noticeArray[indexPath.row])
                }
                self.noticeArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch _ as NSError {
                Analytics.logEvent("error_NoticeTableViewController_tableView_editingStyle", parameters: [AnalyticsParameterItemName:"お知らせリスト(編集)のセルの削除に失敗" as String])
                SVProgressHUD.showError(withStatus: "削除に失敗しました")
            }
        }
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "noticeCellSegue":
            let noticeEditViewController:EditNoticeViewController = segue.destination as! EditNoticeViewController
            let indexPath = self.noticeTable.indexPathForSelectedRow
            noticeEditViewController.notice = noticeArray[indexPath!.row]
        case "editBSegue":
            let noticeEditViewController:EditNoticeViewController = segue.destination as! EditNoticeViewController
            let notice = Notices()
            notice.id = NSUUID().uuidString
            notice.mailAdress = self.mailAdress
            notice.password = self.password
            noticeEditViewController.notice = notice
        default:
            break
        }
    }
}
