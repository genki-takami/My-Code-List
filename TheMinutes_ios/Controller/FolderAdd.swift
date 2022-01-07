/*
 議事録フォルダの追加処理
 */

import UIKit
import RealmSwift
import SVProgressHUD

class FolderAdd: UIViewController {

    // 変数
    @IBOutlet weak var folderNameTextField: UITextField!
    let realm = try! Realm()
    var folder : FolderListModel!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景をタップしたらキーボードを閉じる
        self.view.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard)))
    }
    
    // キーボードを閉じる
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    // フォルダの追加
    @IBAction func addFolder(_ sender: Any) {
        if let name = folderNameTextField.text{
            
            if name.isEmpty{
                SVProgressHUD.showError(withStatus: "フォルダー名を記入してください")
                return
            }
            
            do {
                try realm.write {
                    self.folder.folderName = name
                    self.folder.date = Date()
                    self.realm.add(self.folder, update: .modified)
                }
                // フォルダーリストに戻る
                self.dismiss(animated: true, completion: nil)
                SVProgressHUD.showSuccess(withStatus: "フォルダーを作成しました！")
            } catch _ as NSError {
                SVProgressHUD.showError(withStatus: "フォルダーの作成に失敗！再度お試しください")
                return
            }
        }
    }
}
