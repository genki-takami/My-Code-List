/*
 お気に入りタブの処理
 */

import UIKit
import Firebase
import RealmSwift
import SVProgressHUD

class FavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // 変数
    @IBOutlet weak var favoriteList: UITableView!
    var festivalData: [RealmData] = []
    let realm = try! Realm()
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲート・データソース
        favoriteList.delegate = self
        favoriteList.dataSource = self
        favoriteList.separatorStyle = .none
        // カスタムセルの登録する
        favoriteList.register(UINib(nibName: "FavoriteTableViewCell", bundle: nil), forCellReuseIdentifier: "FavoriteCell")
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        
        // お気に入りデータベースからデータを持ってくる
        self.festivalData.removeAll()
        for i in realm.objects(RealmData.self){
            festivalData.append(i)
        }
        
        // tableViewの表示を更新する
        self.favoriteList.reloadData()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return festivalData.count
    }

    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルの高さを返す
        tableView.rowHeight = 100
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath) as! FavoriteTableViewCell
        cell.setData(festivalData[indexPath.row])
        
        // セルのタップ検知
        let tapGesture = MyTapGestureRecognizer(target:self, action:#selector(goToDetail(sender:)))
        tapGesture.indexValue = indexPath
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    // セルをタップした時に実行
    @objc func goToDetail(sender: MyTapGestureRecognizer){
        tableView(self.favoriteList, didSelectRowAt: sender.indexValue!)
    }
    
    // セルのタップ時の処理を返す
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "viewFromFavoriteSegue",sender: indexPath)
    }
    
    // セルに削除可能か返す
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    // Deleteボタン
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // お気に入りデータベースから削除する
            do {
                try self.realm.write {
                    self.realm.delete(self.festivalData[indexPath.row])
                }
                self.festivalData.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch _ as NSError {
                Analytics.logEvent("error_FavoriteViewController_tableView_editingStyle", parameters: [AnalyticsParameterItemName:"削除に失敗しました" as String])
                SVProgressHUD.showError(withStatus: "削除に失敗しました")
            }
        }
    }
    
    // 画面遷移する時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "viewFromFavoriteSegue"{
            let readingViewController:ReadingViewController = segue.destination as! ReadingViewController
            readingViewController.uuid = festivalData[(sender as! IndexPath).row].id
        }
    }
    
    // メニューを表示
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let delete = UIAction(title: "削除", image: UIImage(systemName: "trash.fill"), identifier: nil){ action in
                self.tableView(tableView, commit: UITableViewCell.EditingStyle.delete, forRowAt: indexPath)
            }
            return UIMenu(title: "アクション", image: nil, identifier: nil, children: [delete])
        }
    }
}
