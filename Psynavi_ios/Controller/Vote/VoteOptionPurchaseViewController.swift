/*
 投票オプションの購入処理
 */

import UIKit

final class VoteOptionPurchaseViewController: UIViewController {

    // MARK: - Property
    @IBOutlet private weak var optionGate: UILabel!
    var upgrade: Bool!
    var uuid: String!
    
    // MARK: - VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if upgrade! || UserDefaultsTask.getPersonalData(uuid) {
            optionGate.text = "購入済み"
            optionGate.backgroundColor = .black
        }
    }
    
    // MARK:  - Purchase
    @IBAction private func purchase(_ sender: Any) {
        
        if !upgrade! && !UserDefaultsTask.getPersonalData(uuid) {
            
            let message = "購入後は必ず保存して下さい\nすでにコンテンツを公開している場合は、再度公開してアップデートして下さい"
            let alertController = UIAlertController(title: "重要", message: message, preferredStyle: .alert)
            
            let actionYes = UIAlertAction(title: "購入する", style: .default) { action in
                StoreManager.shared.purchaseProduct("psynavi.vote.option", self.uuid)
                /// optionGuide.textを変更するために閉じる
                self.dismiss(animated: true, completion: nil)
            }
            let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            
            alertController.addAction(actionYes)
            alertController.addAction(actionCancel)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}
