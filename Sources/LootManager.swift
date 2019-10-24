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
    func loot(_ lootManager: LootManager, didFinishPurchaseWithResult result: Loot.PurchaseResult) -> Void
    func loot(_ lootManager: LootManager, didFinishRestoreWithResult result: Loot.RestoreResult) -> Void
}

internal class LootManager: NSObject {
    
    var productIDs: Set<String>
    var products: [SKProduct] = []
    
    var delegate: LootManagerDelegate?
    
    var canMakePurchases: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    init(productIDs: Set<String>) {
        self.productIDs = productIDs
        
        super.init()
        
        let request = SKProductsRequest(productIdentifiers: self.productIDs)
        request.delegate = self
        request.start()
    }

    public func beginPurchase(with productID: String) {
        if self.canMakePurchases {
            guard let product = self.products.first(where: { (product) -> Bool in
                product.productIdentifier == productID
            }) else {
                if let delegate = self.delegate {
                    delegate.loot(self, didFinishPurchaseWithResult: .failure(productID))
                }
                return
            }
            
            let payment = SKPayment(product: product)

            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        } else {
            if let delegate = self.delegate {
                delegate.loot(self, didFinishPurchaseWithResult: .failure(productID))
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
                if let delegate = self.delegate {
                    delegate.loot(self, didFinishPurchaseWithResult: .success(productID))
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                if let delegate = self.delegate {
                    delegate.loot(self, didFinishRestoreWithResult: .success(productID))
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let delegate = self.delegate {
                    delegate.loot(self, didFinishPurchaseWithResult: .failure(productID))
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred:
                if let delegate = self.delegate {
                    delegate.loot(self, didFinishPurchaseWithResult: .deferred(productID))
                }
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
                if let delegate = self.delegate {
                    delegate.loot(self, didFinishRestoreWithResult: .success(productID))
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if let delegate = self.delegate {
                    delegate.loot(self, didFinishRestoreWithResult: .failure(productID))
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
}
