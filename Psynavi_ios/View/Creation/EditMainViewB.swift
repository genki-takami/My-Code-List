/*
 EditMainViewControllerの拡張
 */

import UIKit

extension EditMainViewController {
    
    // 保存するかの確認を表示
    func saveCheck() {
        
        guard let name = name.text else { fatalError() }
        
        let message = "\(name)に関係するすべてのデータの保存"
        let alertController = UIAlertController(title: "下書き保存しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "保存", style: .default) { action in
            
            DisplayPop.show()
            // 条件をクリアできたらFiresbaseにプッシュ
            if self.savingData() {
                self.successCount = 0.1
                self.pushFirebase()
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // 削除するのかの確認を表示
    func deleteCheck() {
        
        let message = "\(name.text ?? "＜名前がありません＞")に関係するすべてのデータとアカウントの削除"
        let alertController = UIAlertController(title: "削除しますか？", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "削除", style: .destructive) { action in
            
            DisplayPop.show()
            // データベースから削除
            self.deleteRealmDatabase()
            // アカウントを削除する
            if let user = AuthModule.currentUser() {
                AuthModule.deleteUser(user) { result in
                    switch result {
                    case .success(let text):
                        DisplayPop.success(text)
                        // 作成などタブに戻る
                        let tabBer = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                        tabBer.modalPresentationStyle = .fullScreen
                        tabBer.selectedIndex = 3
                        self.present(tabBer, animated: true, completion: nil)
                    case .failure(let error):
                        DisplayPop.error(error.localizedDescription)
                        return
                    }
                }
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
}
