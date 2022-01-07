/*
 議事録フォルダリストの処理
 */

import UIKit
import RealmSwift
import SVProgressHUD

class FolderList: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    // 変数
    @IBOutlet weak var folderList: UITableView!
    let realm = try! Realm()
    var folderArray: [FolderListModel] = []
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // SVProgressHUDのセットアップ
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        // デリゲート・データソース
        folderList.delegate = self
        folderList.dataSource = self
    }
    
    // 表示前処理
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // オブジェクトを参照する
        self.folderArray.removeAll()
        for i in realm.objects(FolderListModel.self).sorted(byKeyPath: "date", ascending: false){
            self.folderArray.append(i)
        }
        folderList.reloadData()
    }
    
    // セルの数を返す
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folderArray.count
    }

    // セルの中身を返す
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
        
        let folderName = cell.viewWithTag(1) as! UILabel
        folderName.text = folderArray[indexPath.row].folderName
        
        // セルのロングタップ検知
        let tapGesture = MyLongPressGestureRecognizer(target: self, action: #selector(editFolderName(sender:)))
        tapGesture.indexValue = indexPath
        cell.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    // セルをロングタップした時に実行
    @objc func editFolderName(sender: MyLongPressGestureRecognizer){
        let editFolder = self.folderArray[sender.indexValue!.row]
        let message = "\(editFolder.folderName)の変更"
        let alert = UIAlertController(title: "フォルダー名の変更", message: message, preferredStyle: UIAlertController.Style.alert)
        
        var alertTextField: UITextField?
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
                alertTextField = textField
                textField.text = ""
                textField.placeholder = "新しいフォルダー名"
                // textField.isSecureTextEntry = true
        })
        alert.addAction(UIAlertAction(title: "変更する", style: UIAlertAction.Style.default) { _ in
                self.view.endEditing(true)
                if let text = alertTextField?.text {
                    if text.isEmpty{
                        SVProgressHUD.showError(withStatus: "新しいフォルダー名を入力してください")
                    } else {
                        do {
                            try self.realm.write {
                                editFolder.folderName = text
                                self.realm.add(editFolder, update: .modified)
                            }
                            self.folderList.reloadData()
                            SVProgressHUD.showSuccess(withStatus: "変更完了！")
                        } catch _ as NSError {
                            SVProgressHUD.showError(withStatus: "フォルダー名の変更に失敗")
                        }
                    }
                }
            }
        )
        alert.addAction(UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }

    // セルを選択した時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "minuteListSegue", sender: nil)
    }

    // セルは削除可能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    // 削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除
            do {
                try realm.write {
                    self.realm.delete(self.folderArray[indexPath.row])
                }
                self.folderArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch _ as NSError {
                SVProgressHUD.showError(withStatus: "フォルダーの削除に失敗")
            }
        }
    }
    
    // 遷移時にデータを渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "folderAddSegue"{
            let folderadd:FolderAdd = segue.destination as! FolderAdd
            let newFolder = FolderListModel()
            let allFolders = realm.objects(FolderListModel.self)
            if allFolders.count != 0{
                newFolder.id = allFolders.max(ofProperty: "id")! + 1
            }
            folderadd.folder = newFolder
        } else if segue.identifier == "minuteListSegue"{
            let minuteList:MinuteList = segue.destination as! MinuteList
            let indexPath = self.folderList.indexPathForSelectedRow
            minuteList.folderId = folderArray[indexPath!.row].id
            minuteList.titleName = folderArray[indexPath!.row].folderName
        }
    }
}

