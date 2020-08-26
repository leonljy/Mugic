import Foundation
import SwiftyStoreKit


class AccountManager {
    static let shared = AccountManager()

    func purchase(completion: ((Error?) -> Void)?) {
        SwiftyStoreKit.purchaseProduct("Mugic.Inapp.ProVersion", atomically: true) { results in
            switch results {
            case .success (let _):
//                Answers.logPurchase(withPrice: purchase.product.price,
//                    currency: purchase.product.priceLocale.currencyCode,
//                    success: true,
//                    itemName: nil,
//                    itemType: nil,
//                    itemId: purchase.productId,
//                    customAttributes: ["regionCode": Locale.current.regionCode ?? "Unknown"])
                
                UserDefaults.standard.set(true, forKey: "isProVersion")
                NSUbiquitousKeyValueStore.default.set(true, forKey: "isProVersion")
                completion?(nil)
            case .error(let error):
                completion?(error)
            }
        }
    }

    func restore(completion: ((Error?) -> Void)?) {
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if case (let error, _)? = results.restoreFailedPurchases.first {
                completion?(error)
            }

            if !results.restoredPurchases.isEmpty {
                UserDefaults.standard.set(true, forKey: "isProVersion")
                NSUbiquitousKeyValueStore.default.set(true, forKey: "isProVersion")
            }

            completion?(nil)
        }
    }
}
