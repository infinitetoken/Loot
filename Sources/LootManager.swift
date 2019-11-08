//
//  LootManager.swift
//  Loot
//
//  Created by Aaron Wright on 10/24/19.
//  Copyright © 2019 Infinite Token LLC. All rights reserved.
//

import Foundation
import StoreKit
import Lumber

internal protocol LootManagerDelegate {
    func loot(_ lootManager: LootManager, didFinishWithResult result: Loot.Result) -> Void
}

internal class LootManager: NSObject {
    
    var lumber: Lumber = Lumber()
    
    var productIDs: Set<String>
    var products: [SKProduct] = []
    
    var delegate: LootManagerDelegate?
    
    init(productIDs: Set<String>) {
        self.productIDs = productIDs
        
        super.init()
        
        self.lumber.log("Begin Product Request")
        
        let request = SKProductsRequest(productIdentifiers: self.productIDs)
        request.delegate = self
        request.start()
        
        SKPaymentQueue.default().add(self)
    }

    public func beginPurchase(with productIDs: [String]) {
        self.lumber.log("Begin Purchase: \(productIDs)")
        
        productIDs.forEach { (productID) in
            if SKPaymentQueue.canMakePayments() {
                if let product = self.products.first(where: { $0.productIdentifier == productID }) {
                    SKPaymentQueue.default().add(SKPayment(product: product))
                } else {
                    self.lumber.log("No products matched productIDs")
                    
                    self.delegate?.loot(self, didFinishWithResult: .failure(productID))
                }
            } else {
                self.lumber.log("Product purchases unavailable!")
                
                self.delegate?.loot(self, didFinishWithResult: .failure(productID))
            }
        }
    }

    public func beginRestore() {
        self.lumber.log("Begin Restore")
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

extension LootManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        
        self.lumber.log("Products Received: \(self.products)")
    }
    
}

extension LootManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            let productID = transaction.payment.productIdentifier

            self.lumber.log("Payment Queue Updated (Product ID): \(productID)")
            self.lumber.log("Payment Queue Updated (Transaction State): \(transaction.transactionState)")
            
            switch transaction.transactionState {
            case .purchasing:
                break
            case .purchased:
                self.delegate?.loot(self, didFinishWithResult: .success(productID))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                self.delegate?.loot(self, didFinishWithResult: .success(productID))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                self.delegate?.loot(self, didFinishWithResult: .failure(productID))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                self.delegate?.loot(self, didFinishWithResult: .deferred(productID))
                break
            default:
                break
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        for transaction in queue.transactions {
            let productID = transaction.payment.productIdentifier
            
            self.lumber.log("Payment Queue Restore (Product ID): \(productID)")
            self.lumber.log("Payment Queue Restore (Transaction State): \(transaction.transactionState)")
            
            switch transaction.transactionState {
            case .restored:
                self.delegate?.loot(self, didFinishWithResult: .success(productID))
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                self.delegate?.loot(self, didFinishWithResult: .failure(productID))
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
}
