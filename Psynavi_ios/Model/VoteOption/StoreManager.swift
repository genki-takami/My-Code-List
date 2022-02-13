/*
 App内課金の設定ファイル
 */

import Foundation
import StoreKit
import Firebase

final class StoreManager: NSObject, SKPaymentTransactionObserver {
    
    // MARK: - MAIN
    static var shared = StoreManager()
    
    // MARK: - Property
    var products = [SKProduct]()
    var uuid: String!
    let productsIdentifiers: Set<String> = ["psynavi.vote.option"]
    private var productRequest: SKProductsRequest?
    
    // MARK: - INITIALIZE
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
    
    // MARK: - PURCHASE
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
            
            DisplayPop.showMessage("購入手続き中")
            
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction)
            case .failed:
                DisplayPop.error("購入失敗[Purchase Failed]")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing, .deferred, .restored:
                break
            @unknown default:
                DisplayPop.error("ERROR Please Try Again")
                break
            }
        }
    }
    
    // MARK: - COMPLETE PURCHASE
    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            
            do {
                let rawReceiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptData = rawReceiptData.base64EncodedString(options: [])
                // 自身のサーバーにレシート文字列を送信する
                PostData.receiptUpload(self.uuid, receiptData) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        break
                    }
                    // TODO: レシートの送信を完璧にする
                    DisplayPop.success("購入しました！\n必ず保存して下さい")
                    DataProcessing.setPersonalData(true, self.uuid)
                    SKPaymentQueue.default().finishTransaction(transaction)
                }
            } catch {
                DisplayPop.success("購入しました！\n必ず保存して下さい")
                DataProcessing.setPersonalData(true, self.uuid)
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
