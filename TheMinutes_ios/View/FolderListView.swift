/*
 FolderListViewControllerの拡張
 */

import UIKit

extension FolderListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "minuteListSegue", sender: nil)
    }
}

extension FolderListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return folders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "folderCell", for: indexPath)
        
        let folderName = cell.viewWithTag(1) as! UILabel
        folderName.text = folders[indexPath.row].folderName
        
        // セルのロングタップ
        let tapGesture = MyLongPressGestureRecognizer(target: self, action: #selector(editFolderName(sender:)))
        tapGesture.indexValue = indexPath
        cell.addGestureRecognizer(tapGesture)
        
        // セルのハイライトを無くす
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // データベースから削除
        if editingStyle == .delete {
            DataProcessing.delete(folders[indexPath.row], RealmModel.folder) { result in
                switch result {
                case .success(let text):
                    DisplayPop.success(text)
                    self.folders.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    DisplayPop.error(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - LONG TAP THE CELL
    @objc func editFolderName(sender: MyLongPressGestureRecognizer) {
        
        let editFolder = folders[sender.indexValue!.row]
        let message = "\(editFolder.folderName)の変更"
        
        let alert = UIAlertController(title: "フォルダー名の変更", message: message, preferredStyle: UIAlertController.Style.alert)
        
        // テキスト入力エリアを設置
        var alertTextField: UITextField?
        alert.addTextField { (textField: UITextField!) in
            alertTextField = textField
            textField.text = ""
            textField.placeholder = "新しいフォルダー名"
        }
        // 変更する
        alert.addAction(UIAlertAction(title: "変更する", style: UIAlertAction.Style.default) { _ in
            self.view.endEditing(true)
            
            guard let text = alertTextField?.text else { return }
            if text.isEmpty {
                DisplayPop.error("新しいフォルダー名を入力してください")
            } else {
                let data = [
                    "newFolderName": text
                ]
                DataProcessing.add(editFolder, data, EditMode.modifyFolder, RealmModel.folder) { result in
                    switch result {
                    case .success(let text2):
                        DisplayPop.success(text2)
                        self.folderList.reloadData()
                    case .failure(let error):
                        DisplayPop.error(error.localizedDescription)
                    }
                }
            }
            }
        )
        // キャンセル
        alert.addAction(UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
