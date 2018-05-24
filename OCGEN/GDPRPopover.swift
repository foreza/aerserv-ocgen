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
        
        // On the initial view load, do the following:
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Otherwise, continue to show it
        }
        
        override func viewDidAppear(_ animated:Bool) {
            super.viewDidAppear(false)

            // If we are not in edit mode and GDPR is currently enabled, go right to the MainViewController
        
            if (!gdpr.getEditMode() && gdpr.getConsentState()) {
                print("[DEBUG] - viewDidAppear getGDPRConsentValue is true" )
                performSegue(withIdentifier: "GiveConsent", sender: nil)
            }
        }
        

       
        @IBAction func giveConsent(_ sender: Any) {
            gdpr.setConsentState(toSet: true)
        }
        
        @IBAction func noConsent(_ sender: Any) {
            gdpr.setConsentState(toSet: false)
        }
        
        
    }


