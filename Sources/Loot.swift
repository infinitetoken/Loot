//
//  Loot.swift
//  Loot
//
//  Created by Aaron Wright on 10/24/19.
//  Copyright © 2019 Infinite Token LLC. All rights reserved.
//

import Foundation
import StoreKit

public protocol LootDelegate {
    func loot(_ loot: Loot, didFinishPurchase withResult: Loot.PurchaseResult) -> Void
    func loot(_ loot: Loot, didFinishRestore withResult: Loot.RestoreResult) -> Void
}

public struct Loot {
    
    public enum PurchaseResult {
        case success(String)
        case failure(String)
        case deferred(String)
    }
    
    public enum RestoreResult {
        case success(String)
        case failure(String)
    }
    
    public static var shared: Loot = Loot()
    
    public var delegate: LootDelegate?
    
    public var productIDs: [String] = [] {
        didSet {
            self.manager = LootManager(productIDs: Set(self.productIDs.map { $0 }))
            self.manager.delegate = self
        }
    }
    
    public var canMakePurchases: Bool {
        return self.manager.canMakePurchases
    }
    
    private var manager: LootManager!
    
    // MARK: - Methods
    
    public func purchase(productIDs: [String]) {
        self.manager.beginPurchase(with: productIDs)
    }
    
    public func restore() {
        self.manager.beginRestore()
    }
    
    public func isPurchased(productID: String) -> Bool {
        return UserDefaults.standard.bool(forKey: productID)
    }
    
}

extension Loot: LootManagerDelegate {
    
    func loot(_ lootManager: LootManager, didFinishPurchaseWithResult result: Loot.PurchaseResult) {
        switch result {
        case .success:
            //        UserDefaults.standard.set(true, forKey: "RemoveAdsPurchased")
            //        UserDefaults.standard.synchronize()
            break
        case .failure:
            break
        case .deferred:
            break
        }
        
        if let delegate = self.delegate {
            delegate.loot(self, didFinishPurchase: result)
        }
    }
    
    func loot(_ lootManager: LootManager, didFinishRestoreWithResult result: Loot.RestoreResult) {
        switch result {
        case .success:
            //        UserDefaults.standard.set(true, forKey: "RemoveAdsPurchased")
            //        UserDefaults.standard.synchronize()
            break
        case .failure:
            break
        }
        
        if let delegate = self.delegate {
            delegate.loot(self, didFinishRestore: result)
        }
    }

}
