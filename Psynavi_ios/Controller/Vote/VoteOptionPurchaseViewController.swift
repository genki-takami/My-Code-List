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
        
        if upgrade! || DataProcessing.getPersonalData(uuid) {
            optionGate.text = "購入済み"
            optionGate.backgroundColor = .black
        }
    }
    
    // MARK:  - BUY
    @IBAction private func purchase(_ sender: Any) {
        
        if !upgrade! && !DataProcessing.getPersonalData(uuid) {
            confirmPurchase()
        }
    }
}
