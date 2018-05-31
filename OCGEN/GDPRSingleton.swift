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
    
    // MARK: - Initialization - Initialize the singleton class here.
    
    // Only one instance is ever created and disallow GDPRInstance() with empty constructor
    private init() {
        // print("[DEBUG] GDPR - Singleton instance GDPRInstance created" )
        consentState = AerServSDK.getGDPRConsentValue()
    }
    
    
    // MARK: - Accessors - Access singleton values here
    
    // Return the consent state
    func getConsentState() -> Bool {
        return consentState
    }
    
    // Return the edit mode
    func getEditMode() -> Bool {
        return editMode
    }
    
    
    // MARK: - Mutators - Modify singleton values here

    // Set the consent state to T/F
    func setConsentState(toSet: Bool) {
        AerServSDK.setGDPRWithUserConsent(toSet)
    }
    
    // Set the edit mode to T/F
    func setEditMode(toSet: Bool) {
        editMode = toSet
    }
    
    
}
