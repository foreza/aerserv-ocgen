//
//  VC-Singleton.swift
//  OCGEN
//
//  Created by Jason C on 5/21/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import Foundation

class VCInstance {
    // We only want once intance of this ever.
    static let sharedInstance = VCInstance()
    
    // Initialize variables
    var currencyName = "Energy"
    var amount = 0
    
    // TODO: Don't let others initialize a type of VCInstance using empty constructor
    //This prevents others from using the default '()' initializer for this class.

    private init() {
        print("[DEBUG] VC - Singleton instance VCInstance created" )

    }
    
    // Get the currency name
    func getCurrencyName() -> String {
        return currencyName
    }
    
    // Get the current amount
    func getAmount() -> Int {
        return amount
    }
    
    // Method to increment the amount
    func incrementAmount(toAdd: Int) {
        
        if (toAdd != nil) {
            amount += toAdd
            print("[DEBUG] VC - VC new amount is \(amount)")
        }
        
    }
    
}
