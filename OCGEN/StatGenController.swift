//
//  StatGenController.swift
//  OCGEN
//
//  Created by Jason C on 5/24/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import UIKit
import AerServSDK


class StatGenController: UIViewController, ASAdViewDelegate {
    

    
    // Get a copy of the VC instance
    var vc = VCInstance.sharedInstance
    
    // State Control and other vars
    var isReady = false
    
     // Declare my view variables here
    
        // MARK: - VIEW - View controller functions
    
    // On the initial view load, do the following:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the UI text elements for this view

        // Load the banner
        
    }
    
    
    // Every time the view appears, do the following:
    override func viewWillAppear(_ animated: Bool) {
        
        // Set the energy text using our utility function
        
    }
    
    // Every time the view disappears, do the following:
    override func viewDidDisappear(_ animated: Bool) { }
    

    
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
}
