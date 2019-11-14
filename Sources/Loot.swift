//
//  Loot.swift
//  Loot
//
//  Created by Aaron Wright on 10/24/19.
//  Copyright © 2019 Infinite Token LLC. All rights reserved.
//

import Foundation
import StoreKit

public class Loot {
    
    // MARK: - Types
    
    public enum Result {
        case success(String)
        case failure(String)
        case deferred(String)
    }
    
    // MARK: - Properties
    
    public static var canMakePurchases: Bool { SKPaymentQueue.canMakePayments() }
    
    public var handler: ((Loot.Result) -> ())?
    
    private let productIDs: [String]
    
    private let manager: LootManager
    
    // MARK: - Lifecycle
    
    public init(productIDs: [String], handler: ((Loot.Result) -> ())?) {
        self.productIDs = productIDs
        self.handler = handler
        
        self.manager = LootManager(productIDs: Set(self.productIDs.map { $0 }))
        self.manager.delegate = self
    }
    
    // MARK: - Methods
    
    public func purchase(productIDs: [String]) { self.manager.beginPurchase(with: productIDs) }
    
    public func restore() { self.manager.beginRestore() }
    
}

extension Loot: LootManagerDelegate {
    
    func loot(_ lootManager: LootManager, didFinishWithResult result: Loot.Result) {
        self.handler?(result)
    }

}
