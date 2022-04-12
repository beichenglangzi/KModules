// Developed by Kelin Lyu.
import StoreKit
let IAPDebugAlwaysSucceed: Bool = false
let IAPDebugAlwaysFail: Bool = false
class IAPManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    var request: SKProductsRequest?
    var products: [String : SKProduct] = [:]
    var result: String?
    convenience init(products: Set<String>) {
        self.init()
        SKPaymentQueue.default().add(self)
        self.request?.cancel()
        self.request = SKProductsRequest(productIdentifiers: products)
        self.request!.delegate = self
        self.request!.start()
    }
    func productsRequest(_ request: SKProductsRequest,
                         didReceive response: SKProductsResponse) {
        print("Loading product list...")
        for product in response.products {
            self.products[product.productIdentifier] = product
            print("\(product.productIdentifier) - \(product.localizedTitle) - $\(product.price.floatValue)")
        }
    }
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Failed to load the product list.")
        print("Error: \(error.localizedDescription)")
    }
    func purchase(product: String) {
        self.result = nil
        if let object = self.products[product] {
            print("Buying \(object.productIdentifier)(\(object.localizedTitle))...")
            let payment = SKPayment(product: object)
            SKPaymentQueue.default().add(payment)
        }else{
            self.result = "failed"
            print("Failed!")
        }
    }
    func restore() {
        print("Restoring...")
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    func paymentQueue(_ queue: SKPaymentQueue,
                      updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            let id: String = transaction.payment.productIdentifier
            switch (transaction.transactionState) {
                case .purchased:
                    if(IAPDebugAlwaysFail) {
                        self.result = "failed"
                    }else{
                        self.result = id
                    }
                    print("Purchased \(id)!")
                    SKPaymentQueue.default().finishTransaction(transaction)
                    break
                case .restored:
                    if(IAPDebugAlwaysFail) {
                        self.result = "failed"
                    }else{
                        self.result = id
                    }
                    print("Restored \(id)!")
                    SKPaymentQueue.default().finishTransaction(transaction)
                    break
                case .failed:
                    if(IAPDebugAlwaysSucceed) {
                        self.result = id
                    }else{
                        self.result = "failed"
                    }
                    print("Failed!")
                    if let transactionError = transaction.error as NSError? {
                        if let localizedDescription = transaction.error?.localizedDescription {
                            if transactionError.code != SKError.paymentCancelled.rawValue {
                                print("Error: \(localizedDescription)")
                            }
                        }
                    }
                    SKPaymentQueue.default().finishTransaction(transaction)
                    break
                default:
                    break
            }
        }
    }
    func check()->(String?) {
        if let value = self.result {
            self.result = nil
            return(value)
        }
        return(nil)
    }
}
