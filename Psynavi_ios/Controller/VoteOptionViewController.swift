/*
 投票オプションの購入処理
 */

import UIKit

class VoteOptionViewController: UIViewController {

    // 変数
    @IBOutlet weak var optionGate: UILabel!
    var upgrade: Bool!
    var uuid: String!
    
    // 読み込み
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.upgrade! || UserDefaults.standard.bool(forKey: self.uuid) {
            optionGate.text = "購入済み"
            optionGate.backgroundColor = .black
        }
    }
    
    // 購入する
    @IBAction func purchase(_ sender: Any) {
        if !self.upgrade! && !UserDefaults.standard.bool(forKey: self.uuid) {
            let message = "購入後は必ず保存して下さい\nすでにコンテンツを公開している場合は、再度公開してアップデートして下さい"
            let alertController: UIAlertController = UIAlertController(title: "重要", message: message, preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "購入する", style: .default){ action in
                StoreManager.shared.purchaseProduct("psynavi.vote.option", self.uuid)
                self.dismiss(animated: true, completion: nil)
            }
            let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alertController.addAction(actionYes)
            alertController.addAction(actionCancel)
            present(alertController, animated: true, completion: nil)
        }
    }
}
