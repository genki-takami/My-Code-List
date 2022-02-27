/*
 App内課金の設定ファイル
 */

import StoreKit

final class StoreManager: NSObject, SKPaymentTransactionObserver {
    
    /// 外部からシングルトンオブジェクトにアクセスするための静的変数
    static var shared = StoreManager()
    
    // MARK: - Property
    var products = [SKProduct]()
    private var uuid: String!
    private let productsIdentifiers: Set<String> = ["psynavi.vote.option"]
    private var productRequest: SKProductsRequest?
    
    // MARK: - INITIALIZE
    private override init() {
        super.init()
        
        validateProductsIdentifiersWithRequest()
    }
    
    /// product情報をStoreから取得
    private func validateProductsIdentifiersWithRequest() {
        productRequest = SKProductsRequest(productIdentifiers: productsIdentifiers)
        productRequest?.delegate = self
        productRequest?.start()
    }
    
    // MARK: - PURCHASE
    func purchaseProduct(_ productIdentifier: String, _ uuidKey: String) {
        /// productIdentifierに該当するproduct情報があるかチェック
        let product = products.filter({ (product: SKProduct) -> Bool in
            return product.productIdentifier == productIdentifier
        }).first
        
        guard let product = product else { return }
        /// UUIDを設置
        uuid = uuidKey
        /// 購入リクエスト
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - Payment Queue
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            
            Modal.showMessage("購入手続き中")
            
            switch transaction.transactionState {
            case .purchased:
                completeTransaction(transaction)
            case .failed:
                Modal.showError("購入に失敗しました。\n支払いは完了していません。")
                SKPaymentQueue.default().finishTransaction(transaction)
            case .purchasing, .deferred, .restored:
                break
            @unknown default:
                Modal.showError("エラーが発生しました。\n支払いは完了していません。")
                break
            }
        }
    }
    
    // MARK: - COMPLETE PURCHASE
    private func completeTransaction(_ transaction: SKPaymentTransaction) {
        
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {
            
            do {
                // TODO: レシートの送信を完璧にする
                let rawReceiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                let receiptData = rawReceiptData.base64EncodedString(options: [])
                /// 自身のサーバーにレシート文字列を送信する
                PostData.receiptUpload(self.uuid, receiptData) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(_):
                        break
                    }
                    
                    self.finishPurchase(transaction)
                }
            } catch {
                finishPurchase(transaction)
            }
        }
    }
    
    /// 支払い処理後のアクション
    private func finishPurchase(_ transaction: SKPaymentTransaction) {
        Modal.showSuccess("購入しました！\n必ず保存して下さい")
        UserDefaultsTask.setPersonalData(true, uuid)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}

/// SKProductsRequestの結果は SKProductsRequestDelegateに通知される
extension StoreManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        /// AppStoreConenctで正しく商品情報を登録できていなかったりするとempty
        guard !response.products.isEmpty else { return }
        /// 不正な商品が無いか確認
        guard response.invalidProductIdentifiers.isEmpty else { return }
        /// product情報の取得完了
        products = response.products
    }
}
