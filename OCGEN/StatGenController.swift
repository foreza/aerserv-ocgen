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
    @IBOutlet weak var strValue: UILabel!
    @IBOutlet weak var dexValue: UILabel!
    @IBOutlet weak var conValue: UILabel!
    @IBOutlet weak var intValue: UILabel!
    @IBOutlet weak var wisValue: UILabel!
    @IBOutlet weak var chrValue: UILabel!
    
    var rollValues = [UILabel]()
    
    // MARK: - VIEW - View controller functions
    
    // On the initial view load, do the following:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the UI text elements for this view
        
        // Use rollValues to easily access the @IBOutlet values
        rollValues = [strValue, dexValue,conValue, intValue, wisValue, chrValue]

        
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
    
    @IBAction func doStatRoll(_ sender: Any) {
        
        print("[DEBUG] Doing Stat Roll")
        
        for values in rollValues {
            utilUpdateTextLabel(label: values, value: utilGetRandomNumber(value: 0))
        }

    }
    
    // Utility to update a given text label
    func utilUpdateTextLabel(label : UILabel!, value : Int){
        
        label?.text = String(value)

    }
    
    // Utility to return a random number
    func utilGetRandomNumber(value : Int) -> Int {
        return 5
    }
    
}
