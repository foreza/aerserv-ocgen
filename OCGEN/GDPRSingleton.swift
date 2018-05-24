//
//  GDPRSingleton.swift
//  OCGEN
//
//  Created by Jason C on 5/24/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import AerServSDK

class GDPRInstance {
    
    // We only want once intance of this ever, by defintion of the Singleton
    static let sharedInstance = GDPRInstance()
    
    // Initialize variables. Control amounts, initial amounts, and currency name here
    
    var consentState : Bool = false
    var editMode : Bool = false
    
    // ** [INIT] **
    // Initialize the singleton class here.
    
    private init() {
        
        // Verify that only one instance is ever created
        print("[DEBUG] GDPR - Singleton instance GDPRInstance created" )
        consentState = AerServSDK.getGDPRConsentValue()
        
    }
    
    func getConsentState() -> Bool {
        return consentState
    }
    
    func getEditMode() -> Bool {
        return editMode
    }
    
    func setConsentState(toSet: Bool) {
        AerServSDK.setGDPRWithUserConsent(toSet)
    }
    
    func setEditMode(toSet: Bool) {
        editMode = toSet
    }
    
    
}
