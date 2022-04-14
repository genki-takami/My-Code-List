/*
 購入画面のViewModel
 */

import SwiftUI

final class BillingViewModel: ObservableObject {
    
    @Published var purchaseStatusText = "購入手続きへ"
    @Published var purchaseStatusBackColor: Color = .blue
    private var purchaseFlag = false
    let purchaseAnnotation = Sentences.purchaseAnnotation
    
    
    func setupStatus(with uid: String) {
        if UserDefaultsTask.checkPurchased(uid) {
            Modal.showSuccess(setPurchasedUI())
        }
    }
    
    func setPurchasedUI() -> String {
        purchaseStatusText = "購入済み"
        purchaseStatusBackColor = .black
        purchaseFlag = true
        return purchaseStatusText
    }
    
    func didPurchase(with uid: String) -> Bool {
        if purchaseFlag {
            /// 購入済み
            Modal.showSuccess("購入済み\n必ず保存してください")
            return true
        } else if UserDefaultsTask.checkPurchased(uid) {
            /// 購入済み
            Modal.showSuccess(setPurchasedUI() + "\n必ず保存してください")
            return true
        } else {
            /// 未購入
            return false
        }
    }
    
    func doPurchase(with uid: String) {
        StoreManager.shared.purchaseProduct("psynavi.emate.video.option", uid)
    }
}
