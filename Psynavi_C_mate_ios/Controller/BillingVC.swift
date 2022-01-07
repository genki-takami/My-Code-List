/*
 課金画面
 */

import UIKit
import SVProgressHUD

class BillingVC: UIViewController {

    // 変数
    @IBOutlet weak var buyBtn: UILabel!
    var id: String!
    var buyFlag = false
    
    // 表示後処理
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: self.id){
            buyBtn.text = "購入済み"
            buyBtn.backgroundColor = .black
            self.buyFlag = true
        }
    }
    
    // 課金
    @IBAction func perchase(_ sender: Any) {
        if !self.buyFlag{
            let message = "購入後は「必ず」確認画面から保存して下さい"
            let alertController: UIAlertController = UIAlertController(title: "重要", message: message, preferredStyle: .alert)
            let actionYes = UIAlertAction(title: "購入する", style: .default){ action in
                self.dismiss(animated: true, completion: nil)
                StoreManager.shared.purchaseProduct("psynavi.cmate.video.option", self.id)
            }
            let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
            alertController.addAction(actionYes)
            alertController.addAction(actionCancel)
            present(alertController, animated: true, completion: nil)
        }
    }
}
