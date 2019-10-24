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
    
    static var canMakePurchases: Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    public class func purchase(productID: String) {
         //        let iap = IAPManager(productID: Self.unlockID)
         //        iap.beginPurchase()
    }
    
    public class func restore(productID: String) {
        //        let iap = IAPManager(productID: Self.unlockID)
        //        iap.beginRestorePurchases()
    }
    
    public class func isPurchased(productID: String) -> Bool {
        //        return UserDefaults.standard.bool(forKey: productID)

        return false
    }
    
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
