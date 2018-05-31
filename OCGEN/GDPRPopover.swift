//
//  GDPR-Popover.swift
//  OCGEN
//
//  Created by Jason C on 5/24/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import UIKit

    // This view will load each time the app is run.
    class GDPRPopover: UIViewController {
        
        
        // Get an instance of the GDPR shared instance
        var gdpr = GDPRInstance.sharedInstance
        
        
        // MARK: - VIEW - View controller functions
        
        // Listener for viewDidLoad
        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        // Listener for viewDidAppear
        override func viewDidAppear(_ animated:Bool) {
            super.viewDidAppear(false)

            // If we are not in edit mode and GDPR is currently enabled, go right to the MainViewController
            if (!gdpr.getEditMode() && gdpr.getConsentState()) {
                // print("[DEBUG] - viewDidAppear getGDPRConsentValue is true" )
                performSegue(withIdentifier: "GiveConsent", sender: nil)
            }
        }
        
        
        // MARK: - IBAction - Indicate consent functions called by the storyboard
        
        // Button press that will indicate to the GDPR singleton instance to set consent to: true
        @IBAction func giveConsent(_ sender: Any) {
            gdpr.setConsentState(toSet: true)
        }
        
        // Button press that will indicate to the GDPR singleton instance to set consent to: false
        @IBAction func noConsent(_ sender: Any) {
            gdpr.setConsentState(toSet: false)
        }
        
        
    }


