/*
 VoteOptionPurchaseViewControllerの拡張
 */

import UIKit

extension VoteOptionPurchaseViewController {
    
    func confirmPurchase() {
        
        let message = "購入後は必ず保存して下さい\nすでにコンテンツを公開している場合は、再度公開してアップデートして下さい"
        let alertController = UIAlertController(title: "重要", message: message, preferredStyle: .alert)
        let actionYes = UIAlertAction(title: "購入する", style: .default) { action in
            StoreManager.shared.purchaseProduct("psynavi.vote.option", self.uuid)
            self.dismiss(animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(actionYes)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)
    }
}
