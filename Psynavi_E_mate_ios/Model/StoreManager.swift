/*
 App内課金の設定ファイル
 */

import Foundation
import StoreKit
import SVProgressHUD

class StoreManager: NSObject, SKPaymentTransactionObserver {
    // 本体
    static var shared = StoreManager()
    
    // 変数
    var products: [SKProduct] = []
    var uuid: String!
    let productsIdentifiers: Set<String> = ["psynavi.emate.video.option"]
    private var productRequest: SKProductsRequest?
    
    // 初期化
    private override init() {
        super.init()
        validateProductsIdentifiersWithRequest()
    }
    
    // product情報をStoreから取得
    func validateProductsIdentifiersWithRequest() {
        productRequest = SKProductsRequest(productIdentifiers: productsIdentifiers)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    // 購入
    func purchaseProduct(_ productIdentifier: String, _ uuidKey: String) {
        // productIdentifierに該当するproduct情報があるかチェック
        let product = products.filter({ (product: SKProduct) -> Bool in
            return product.productIdentifier == productIdentifier
        }).first
        
        if let product = product {
            // UUIDを設置
            uuid = uuidKey
            // 購入リクエスト
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        } else {
            return
        }
    }
    
    // transactionsが変わるたびに呼ばれる
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            SVProgressHUD.show(withStatus: "購入手続き中")
            switch transaction.transactionState {
            case .purchased:
                UserDefaults.standard.setValue(true, forKey: self.uuid)
                SVProgressHUD.showSuccess(withStatus: "購入しました！\n必ず保存して下さい")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                SVProgressHUD.showError(withStatus: "購入失敗[Purchase Failed]")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing, .deferred, .restored:
                break
            @unknown default:
                SVProgressHUD.showError(withStatus: "ERROR Please Try Again")
                break
            }
        }
    }
}

// SKProductsRequestの結果は SKProductsRequestDelegateに通知される
extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // AppStoreConenctで正しく商品情報を登録できていなかったりするとempty
        guard !response.products.isEmpty else {
            return
        }
        // 不正な商品が無いか確認
        guard response.invalidProductIdentifiers.isEmpty else {
            return
        }
        // product情報の取得完了
        products = response.products
    }
}
