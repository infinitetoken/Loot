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
    func loot(_ lootManager: LootManager, didFinishWithResult result: Loot.Result) -> Void
}

internal class LootManager: NSObject {
    
    var productIDs: Set<String>
    var products: [SKProduct] = []
    
    var delegate: LootManagerDelegate?
    
    var canMakePurchases: Bool { SKPaymentQueue.canMakePayments() }
    
    init(productIDs: Set<String>) {
        self.productIDs = productIDs
        
        super.init()
        
        let request = SKProductsRequest(productIdentifiers: self.productIDs)
        request.delegate = self
        request.start()
    }

    public func beginPurchase(with productIDs: [String]) {
        productIDs.forEach { (productID) in
            if self.canMakePurchases {
                if let product = self.products.first(where: { $0.productIdentifier == productID }) {
                    SKPaymentQueue.default().add(self)
                    SKPaymentQueue.default().add(SKPayment(product: product))
                } else {
                    self.delegate?.loot(self, didFinishWithResult: .failure(productID))
                }
            } else {
                self.delegate?.loot(self, didFinishWithResult: .failure(productID))
            }
        }
    }

    public func beginRestore() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

extension LootManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }
    
}

extension LootManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            let productID = transaction.payment.productIdentifier

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
