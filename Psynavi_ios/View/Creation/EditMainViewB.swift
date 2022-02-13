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
}
