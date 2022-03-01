/*
 FolderListViewControllerの拡張
 */

import UIKit

extension FolderListViewController: UITableViewDelegate {
    
    /// セルのタップ
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "minuteListSegue", sender: nil)
    }
    
    /// 更新
    func reloadTable() {
        folderList.reloadData()
    }
}

extension FolderListViewController: UITableViewDataSource {
    
    /// セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    /// セルの内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
        
        let folderName = cell.viewWithTag(1) as! UILabel
        folderName.text = folders[indexPath.row].folderName
        
        /// タップしたインデックス
        let tapGesture = MyLongPressGestureRecognizer(target: self, action: #selector(editFolderName(sender:)))
        tapGesture.indexValue = indexPath
        cell.addGestureRecognizer(tapGesture)
        
        /// セルのハイライトを無くす
        cell.selectionStyle = .none
        
        return cell
    }
    
    /// セルは削除可能
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }
    
    /// データベースから削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            RealmTask.delete(folders[indexPath.row], RealmModel.folder) { result in
                switch result {
                case .success(let text):
                    Modal.showSuccess(text)
                    self.folders.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    Modal.showError(String(describing: error))
                }
            }
        }
    }
    
    // MARK: - LONG TAP THE CELL
    @objc func editFolderName(sender: MyLongPressGestureRecognizer) {
        
        let editFolder = folders[sender.indexValue!.row]
        
        let message = "\(editFolder.folderName)の変更"
        let alert = UIAlertController(title: "フォルダー名の変更", message: message, preferredStyle: UIAlertController.Style.alert)
        
        /// テキスト入力エリアを設置
        var alertTextField: UITextField?
        alert.addTextField { (textField: UITextField!) in
            alertTextField = textField
            textField.text = ""
            textField.placeholder = "新しいフォルダー名"
        }
        
        let actionChange = UIAlertAction(title: "変更する", style: UIAlertAction.Style.default) { _ in
            
            self.view.endEditing(true)
            
            guard let text = alertTextField?.text else { return }
            
            if text.isEmpty {
                Modal.showError("新しいフォルダー名を入力してください")
            } else {
                
                let data = [
                    "newFolderName": text,
                ]
                
                RealmTask.add(editFolder, data, EditMode.modifyFolder, RealmModel.folder) { result in
                    switch result {
                    case .success(let message):
                        Modal.showSuccess(message)
                        self.reloadTable()
                    case .failure(let error):
                        Modal.showError(String(describing: error))
                    }
                }
            }
        }
        alert.addAction(actionChange)
        alert.addAction(UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
