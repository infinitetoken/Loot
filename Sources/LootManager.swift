//
//  LootManager.swift
//  Loot
//
//  Created by Aaron Wright on 10/24/19.
//  Copyright © 2019 Infinite Token LLC. All rights reserved.
//

import Foundation
import StoreKit

internal protocol LootManagerDelegate {
    func loot(_ lootManager: LootManager, didBecomeReadyWithProducts products: [SKProduct]) -> Void
    func loot(_ lootManager: LootManager, didFinishWithResult result: Loot.Result) -> Void
}

internal class LootManager: NSObject {
    
    var productIDs: Set<String>
    var products: [SKProduct] = []
    
    var delegate: LootManagerDelegate?
    
    init(productIDs: Set<String>) {
        self.productIDs = productIDs
        
        super.init()
        
        Swift.print("Begin Product Request")
        
        let request = SKProductsRequest(productIdentifiers: self.productIDs)
        request.delegate = self
        request.start()
        
        SKPaymentQueue.default().add(self)
    }

    public func beginPurchase(with productIDs: [String]) {
        Swift.print("Begin Purchase: \(productIDs)")
        
        productIDs.forEach { (productID) in
            if SKPaymentQueue.canMakePayments() {
                if let product = self.products.first(where: { $0.productIdentifier == productID }) {
                    SKPaymentQueue.default().add(SKPayment(product: product))
                } else {
                    Swift.print("No products matched productIDs")
                    
                    self.delegate?.loot(self, didFinishWithResult: .failure(productID))
                }
            } else {
                Swift.print("Product purchases unavailable!")
                
                self.delegate?.loot(self, didFinishWithResult: .failure(productID))
            }
        }
    }

    public func beginRestore() {
        Swift.print("Begin Restore")
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

extension LootManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        
        self.delegate?.loot(self, didBecomeReadyWithProducts: self.products)
        
        Swift.print("Products Received: \(self.products)")
    }
    
}

extension LootManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            let productID = transaction.payment.productIdentifier

            Swift.print("Payment Queue Updated (Product ID): \(productID)")
            Swift.print("Payment Queue Updated (Transaction State): \(transaction.transactionState)")
            
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
            
            Swift.print("Payment Queue Restore (Product ID): \(productID)")
            Swift.print("Payment Queue Restore (Transaction State): \(transaction.transactionState)")
            
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
