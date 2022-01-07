/*
 App内課金の設定ファイル
 */

import Foundation
import StoreKit
import Firebase
import SVProgressHUD

class StoreManager: NSObject, SKPaymentTransactionObserver {
    // 本体
    static var shared = StoreManager()
    
    // 変数
    var products: [SKProduct] = []
    var uuid: String!
    let productsIdentifiers: Set<String> = ["psynavi.vote.option"]
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
                completeTransaction(transaction)
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
    
    // 購入が完了した後の処理
    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            do {
                let rawReceiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptData = rawReceiptData.base64EncodedString(options: [])
                // 自身のサーバーにレシート文字列を送信する
                let firestore = Firestore.firestore()
                let path1 = firestore.collection("receipts").document(self.uuid)
                let path2 = firestore.collection(Const.DraftPath).document(self.uuid)
                let batch = firestore.batch()
                batch.setData(["receiptString": receiptData, "timestamp" : Timestamp(date: Date())], forDocument: path1)
                batch.setData(["upgrade" : true], forDocument: path2, merge: true)
                batch.commit() { err in
                    if let _ = err {
                        Analytics.logEvent("error_StoreManager_completeTransaction_err", parameters: [AnalyticsParameterItemName:"レシートの発行に失敗" as String])
                    }
                    SVProgressHUD.showSuccess(withStatus: "購入しました！\n必ず保存して下さい")
                    UserDefaults.standard.setValue(true, forKey: self.uuid)
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
            } catch {
                Analytics.logEvent("error_StoreManager_completeTransaction_catch", parameters: [AnalyticsParameterItemName:"レシートの発行に失敗" as String])
                SVProgressHUD.showSuccess(withStatus: "購入しました！\n必ず保存して下さい")
                UserDefaults.standard.setValue(true, forKey: self.uuid)
                SKPaymentQueue.default().finishTransaction(transaction)
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
