//
//  LootManager.swift
//  Loot
//
//  Created by Aaron Wright on 10/24/19.
//  Copyright © 2019 Infinite Token LLC. All rights reserved.
//

import Foundation
import StoreKit

private class LootManager: NSObject {
    
    let productID: String
    
    var canMakePurchases: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    init(productID: String) {
        self.productID = productID
    }

    public func beginPurchase() {
        if self.canMakePurchases {
            let request = SKProductsRequest(productIdentifiers: [self.productID])
            request.delegate = self
            request.start()
        } else {
            // Otherwise, tell the user that
            // they are not authorized to make payments,
            // due to parental controls, etc
        }
    }

    public func beginRestorePurchases() {
        // restore purchases, and give responses to self
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

extension LootManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // Let's try to get the first product from the response
        // to the request
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
    }
    
}

extension LootManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            // get the producted ID from the transaction
            let productID = transaction.payment.productIdentifier

            // In this case, we have only one IAP, so we don't need to check
            // what IAP it is.
            // However, if you have multiple IAPs, you'll need to use productID
            // to check what functions you should run here!

            switch transaction.transactionState {
            case .purchasing:
                // if the user is currently purchasing the IAP,
                // we don't need to do anything.
                //
                // You could use this to show the user
                // an activity indicator, or something like that
                break
            case .purchased:
                // the user successfully purchased the IAP!
                //RemoveAdsManager.removeAdsSuccess()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                // the user restored their IAP!
                //IAPTestingHandler.restoreRemoveAdsSuccess()
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                // The transaction failed!
                //RemoveAdsManager.removeAdsFailure()
                // finish the transaction
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                // This happens when the IAP needs an external action
                // in order to proceeded, like Ask to Buy
                //RemoveAdsManager.removeAdsDeferred()
                break
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        // For every transaction in the transaction queue...
        for transaction in queue.transactions{
            // If that transaction was restored
            if transaction.transactionState == .restored {
                // get the producted ID from the transaction
                let productID = transaction.payment.productIdentifier

                // In this case, we have only one IAP, so we don't need to check
                // what IAP it is. However, this is useful if you have multiple IAPs!
                // You'll need to figure out which one was restored
                if(productID.lowercased() == self.productID.lowercased()){
                    // Restore the user's purchases
                    //RemoveAdsManager.restoreRemoveAdsSuccess()
                }

                // finish the payment
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
    
}
