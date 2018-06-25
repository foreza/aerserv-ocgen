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
    @IBOutlet weak var statSummary: UILabel!
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
        
        // Use rollValues to easily access the @IBOutlet values
        rollValues = [strValue, dexValue,conValue, intValue, wisValue, chrValue]
        
    }
    
    
    // Every time the view appears, do the following:
    override func viewWillAppear(_ animated: Bool) {
        // TODO: Set the energy text using our utility function
    }
    
    // Every time the view disappears, do the following:
    override func viewDidDisappear(_ animated: Bool) { }

//    // Dependency of ASAdViewDelegate
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    // MARK: - Stat Roll - Functions that will call other util / metric functions to provide stat rolls
    
    // Main function called by button press to perform a stat roll
    @IBAction func doStatRoll(_ sender: Any) {
        
        // print("[DEBUG] doStatRoll - Doing Stat Roll")
        
        // Declare any sort of metric collection totals
        var rollTotal = 0;
        
        for values in rollValues {
            
            // Perform the roll
            let rollVal = roll4D6DropLowest()
            
            // Do any sort of metrics collection here
            rollTotal += rollVal
            
            // Update the view
            util_updateTextLabel(label: values, value: rollVal)
        }
        
        // Perform metrics
        metrics_analyzeRoll(type: 0, value: rollTotal)
        
        // Decrement VC
        vc.decrementAmount(toTake: vc.getSpendAmount())


    }
    
    // Main function to calculate the 4D6 roll
    func roll4D6DropLowest() -> Int {
        
        var statArr = [0,0,0,0]        // Declare an array
        
        for (index, stat) in statArr.enumerated() {
            let statSeed = util_getRandomNumber(value: 6)
            statArr[index] = statSeed
            print("[DEBUG] - utilRoll4D6DropLowest \(index) : \(statSeed)" )
            
        }
        
        let statVal = statArr.reduce(0, { x, y in
            x + y
        })
        
        print("[DEBUG] - roll4D6DropLowest statVal is : \(statVal)")
        
        
        let finalStatVal = statVal - statArr.min()!
        
        print("[DEBUG] - roll4D6DropLowest finalStatVal is : \(finalStatVal) after dropping \(statArr.min()!)")
        
        
        return finalStatVal
    }
    
    // MARK: - Metrics - Functions that will parse data and provide insight about the rolls
    
    // Function to analyze the roll that was just performed
    func metrics_analyzeRoll(type: Int, value : Int){
        
        /*
         roll4D6DropLowest = 0
         roll3D6 = 1
         roll 3D6 x3 highest = 2
         */
        
        print ("[DEBUG] - metrics_analyzeRoll roll total was: \(value) ")
        
        statSummary?.text = "metrics_analyzeRoll roll total was: \(value)"
        
    }
    
    
    // MARK: - Utility - Util functions that will perform basic but critical tasks many times

    
    // Utility to update a given text label
    func util_updateTextLabel(label : UILabel!, value : Int){
        label?.text = String(value)
    }
    
    // Utility to return a random number using arc4random_uniform
    func util_getRandomNumber(value : Int) -> Int {
        let n = Int(arc4random_uniform(UInt32(value)))
        return n + 1
    }
    
   
    
}
