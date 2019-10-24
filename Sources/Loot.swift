//
//  Loot.swift
//  Loot
//
//  Created by Aaron Wright on 10/24/19.
//  Copyright © 2019 Infinite Token LLC. All rights reserved.
//

import Foundation
import StoreKit

public class Loot: NSObject {
    
}

//public class IAPUnlock {
//
//    static let unlockID = "com.infinitetoken.SlideDesigner.Unlock"
//
//    // Call this when the user wants
//    // to remove ads, like when they
//    // press a "remove ads" button
//    class func purchase(productID: String) {
//        // Before starting the purchase, you could tell the
//        // user that their purchase is happening, maybe with
//        // an activity indicator
//
//        let iap = IAPManager(productID: Self.unlockID)
//        iap.beginPurchase()
//    }
//
//    // Call this when the user wants
//    // to restore their IAP purchases,
//    // like when they press a "restore
//    // purchases" button.
//    class func restoreRemoveAds() {
//        // Before starting the purchase, you could tell the
//        // user that the restore action is happening, maybe with
//        // an activity indicator
//
//        let iap = IAPManager(productID: Self.unlockID)
//        iap.beginRestorePurchases()
//    }
//
//    // Call this to check whether or not
//    // ads are removed. You can use the
//    // result of this to hide or show
//    // ads
//    class func areAdsRemoved() -> Bool {
//        // This is the code that is run to check
//        // if the user has the IAP.
//
//        return UserDefaults.standard.bool(forKey: "RemoveAdsPurchased")
//    }
//
//    // This will be called by IAPManager
//    // when the user sucessfully purchases
//    // the IAP
//    class func removeAdsSuccess() {
//        // This is the code that is run to actually
//        // give the IAP to the user!
//        //
//        // I'm using UserDefaults in this example,
//        // but you may want to use Keychain,
//        // or some other method, as UserDefaults
//        // can be modified by users using their
//        // computer, if they know how to, more
//        // easily than Keychain
//
//        UserDefaults.standard.set(true, forKey: "RemoveAdsPurchased")
//        UserDefaults.standard.synchronize()
//    }
//
//    // This will be called by IAPManager
//    // when the user sucessfully restores
//    //  their purchases
//    class func restoreRemoveAdsSuccess() {
//        // Give the user their IAP back! Likely all you'll need to
//        // do is call the same function you call when a user
//        // sucessfully completes their purchase. In this case, removeAdsSuccess()
//        removeAdsSuccess()
//    }
//
//    // This will be called by IAPManager
//    // when the IAP failed
//    class func removeAdsFailure() {
//        // Send the user a message explaining that the IAP
//        // failed for some reason, and to try again later
//    }
//
//    // This will be called by IAPManager
//    // when the IAP gets deferred.
//    class func removeAdsDeferred() {
//        // Send the user a message explaining that the IAP
//        // was deferred, and pending an external action, like
//        // Ask to Buy.
//    }
//
//}

//class IAPManager: NSObject {
//
//    let productID: String
//
//    var canMakePurchases: Bool {
//        return SKPaymentQueue.canMakePayments()
//    }
//
//    init(productID: String) {
//        self.productID = productID
//    }
//
//    public func beginPurchase() {
//        if self.canMakePurchases {
//            let request = SKProductsRequest(productIdentifiers: [self.productID])
//            request.delegate = self
//            request.start()
//        } else {
//            // Otherwise, tell the user that
//            // they are not authorized to make payments,
//            // due to parental controls, etc
//        }
//    }
//
//    public func beginRestorePurchases() {
//        // restore purchases, and give responses to self
//        SKPaymentQueue.default().add(self)
//        SKPaymentQueue.default().restoreCompletedTransactions()
//    }
//
//}
//
//extension IAPManager: SKProductsRequestDelegate {
//
//    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
//        // Let's try to get the first product from the response
//        // to the request
//        if let product = response.products.first {
//            let payment = SKPayment(product: product)
//
//            SKPaymentQueue.default().add(self)
//            SKPaymentQueue.default().add(payment)
//        } else {
//            // Something went wrong! It is likely that either
//            // the user doesn't have internet connection, or
//            // your product ID is wrong!
//            //
//            // Tell the user in requestFailed() by sending an alert,
//            // or something of the sort
//
//            //RemoveAdsManager.removeAdsFailure()
//        }
//    }
//
//}
//
//extension IAPManager: SKPaymentTransactionObserver {
//
//    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        for transaction in transactions {
//            // get the producted ID from the transaction
//            let productID = transaction.payment.productIdentifier
//
//            // In this case, we have only one IAP, so we don't need to check
//            // what IAP it is.
//            // However, if you have multiple IAPs, you'll need to use productID
//            // to check what functions you should run here!
//
//            switch transaction.transactionState {
//            case .purchasing:
//                // if the user is currently purchasing the IAP,
//                // we don't need to do anything.
//                //
//                // You could use this to show the user
//                // an activity indicator, or something like that
//                break
//            case .purchased:
//                // the user successfully purchased the IAP!
//                //RemoveAdsManager.removeAdsSuccess()
//                SKPaymentQueue.default().finishTransaction(transaction)
//            case .restored:
//                // the user restored their IAP!
//                //IAPTestingHandler.restoreRemoveAdsSuccess()
//                SKPaymentQueue.default().finishTransaction(transaction)
//            case .failed:
//                // The transaction failed!
//                //RemoveAdsManager.removeAdsFailure()
//                // finish the transaction
//                SKPaymentQueue.default().finishTransaction(transaction)
//            case .deferred:
//                // This happens when the IAP needs an external action
//                // in order to proceeded, like Ask to Buy
//                //RemoveAdsManager.removeAdsDeferred()
//                break
//            }
//        }
//    }
//
//    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
//        // For every transaction in the transaction queue...
//        for transaction in queue.transactions{
//            // If that transaction was restored
//            if transaction.transactionState == .restored {
//                // get the producted ID from the transaction
//                let productID = transaction.payment.productIdentifier
//
//                // In this case, we have only one IAP, so we don't need to check
//                // what IAP it is. However, this is useful if you have multiple IAPs!
//                // You'll need to figure out which one was restored
//                if(productID.lowercased() == self.productID.lowercased()){
//                    // Restore the user's purchases
//                    //RemoveAdsManager.restoreRemoveAdsSuccess()
//                }
//
//                // finish the payment
//                SKPaymentQueue.default().finishTransaction(transaction)
//            }
//        }
//    }
//
//}
