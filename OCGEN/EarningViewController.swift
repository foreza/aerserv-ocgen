//
//  SecondViewController.swift
//  OCGEN
//
//  Created by Jason Chiu on 17/05/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import UIKit
import AerServSDK

class EarningViewController: UIViewController, ASInterstitialViewControllerDelegate {
    
    // Get a singleton VC instance
    var vc = VCInstance.sharedInstance
    
    // State Control and other vars
    var interstitialPlacementID = "380315"
    var isPreloading = false
    var preloadReady = false
    
    // Banner and interstitial objects
    var interstitial: ASInterstitialViewController?

    // Declare my view variables here
    @IBOutlet weak var earnEnergyVC: UILabel!
    @IBOutlet weak var showInterstitial: UIButton!
    @IBOutlet weak var adLoadSpinner: UIActivityIndicatorView!
    
    
    // MARK: - VIEW - View controller functions
    
    // On the initial view load, do the following:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set all text elements
        earnEnergyVC?.text = String(vc.getAmount()) + " " +  vc.getCurrencyName();
        
        // Set all view elements
        showInterstitial?.isHidden = true;
        adLoadSpinner?.isHidden = false;
        adLoadSpinner?.startAnimating();

    }
    
    // Every time the view appears, do the following:
    override func viewWillAppear(_ animated: Bool) {
        
        if (!preloadReady) {
            // Preload the interstitial
            preload_interstitial(plc: interstitialPlacementID)
        
            // Set all view elements
            showInterstitial?.isHidden = true;
            adLoadSpinner?.isHidden = false;
            adLoadSpinner?.startAnimating();
        }
 
        // Set all text elements
        earnEnergyVC?.text = String(vc.getAmount()) + " " +  vc.getCurrencyName();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // Called by the initial and the viewWillAppear to pre-load the interstitial
    func preload_interstitial(plc : String) {
        
        if (!isPreloading){
            isPreloading = true
            print("[DEBUG] - BEGIN preload_interstitial")
            interstitial = ASInterstitialViewController(forPlacementID: plc, with:self)
            interstitial?.keyWords = ["Aer", "Serv"]
            interstitial?.locationServicesEnabled = true
            interstitial?.userId = "AerServUser"
            interstitial?.isPreload = true
            interstitial?.loadAd()
        }
        
        print("[DEBUG] - already preloading_interstitial")
 
    }
    
    // Button to show the interstitial
    @IBAction func show_interstitial() {
        interstitial?.show(from: self)
        preloadReady = false
    }

    
    
    // MARK: - ASInterstitialViewController CB - CALL BACK METHODS FOR INTERSTITIALS
    
    // On VC confirmed for ad placement
    func interstitialViewControllerDidVirtualCurrencyLoad(_ viewController: ASInterstitialViewController!, vcData: [AnyHashable : Any]!) {
        print("[DEBUG] @--- Interstitial ad with virtual currency rewarded: name =", vcData["name"] ?? "nil", ", rewardAmount =", vcData["rewardAmount"] ?? "nil", ", buyerName =", vcData["buyerName"] ?? "nil", ", buyerPrice =",  vcData["buyerPrice"] ?? "nil", " ---@")
    }
    
    // On VC awarded
    func interstitialViewControllerDidVirtualCurrencyReward(_ viewController: ASInterstitialViewController!, vcData: [AnyHashable : Any]!) {
        print("[DEBUG] @--- Interstitial ad did reward virtual curreny: name =", vcData["name"] ?? "nil", ", rewardAmount =", vcData["rewardAmount"] ?? "nil", "buyerName =", vcData["buyerName"] ?? "nil", ", buyerPrice =",  vcData["buyerPrice"] ?? "nil", " ---@")
        
        // Increment the VC in the singleton instance
        if let result = vcData["rewardAmount"] as? Int {
            vc.incrementAmount(toAdd: result)
        }
    }
    
    // On Ad preloaded
    func interstitialViewControllerDidPreloadAd(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG] @--- [PRELOAD] Interstitial ad preload ready ---@");
        preloadReady = true
        isPreloading = false
        showInterstitial?.isHidden = false
        adLoadSpinner.stopAnimating()
        adLoadSpinner.isHidden = true

    }
    
    // On ad loaded (not used)
    func interstitialViewControllerAdLoadedSuccessfully(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG] @--- [NO PRELOAD] Interstitial ad loaded ---@")
        interstitial?.show(from: self)
    }
    
    // On ad shown
    func interstitialViewController(_ viewController: ASInterstitialViewController!, didShowAdWithTransactionInfo transcationData: [AnyHashable : Any]!) {
        print("[DEBUG] @--- Interstitial ad has transaction info: buyerName = ", transcationData["buyerName"] ?? "nil", ", buyerPrice = ",  transcationData["buyerPrice"] ?? "nil", " ---@")
    }
    
    
    func interstitialViewControllerWillAppear(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG] @--- Interstitial ad will appear ---@")
    }
    
    func interstitialViewControllerDidAppear(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG] @--- Interstitial ad did appear ---@")
    }
    
    func interstitialViewControllerAdWasTouched(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG] @--- Interstitial ad was clicked ---@")
    }
    
    func interstitialViewControllerAdInteraction(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG] @--- Interstitial ad has interaction ---@")
    }
    
    func interstitialViewControllerAdFailed(toLoad viewController: ASInterstitialViewController!, withError error: Error!) {
        print("[DEBUG] @--- Interstitial ad failed: ", error, " ---@")
    }
    
    func interstitialViewControllerAdDidComplete(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG] @--- Interstitial ad was completed ---@")
    }
    
    func interstitialViewControllerWillDisappear(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG] @--- Interstitial ad will disappear ---@")
    }
    
    func interstitialViewControllerDidDisappear(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG] @--- Interstitial ad did disappear ---@")
    }
    

    
    // Experimental Area
    
    var secondaryInterstitialPlacementID = "380004"
    var secondaryInterstitial: ASInterstitialViewController?

    
    // PII-509
    func startSomethingWithDelayOnMain() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) { // 2
            print("[DEBUG] Main - startSomethingWithDelayOnMain: ", self.secondaryInterstitialPlacementID)
            self.preload_secondary_interstitial(plc: self.secondaryInterstitialPlacementID)
        }
    }
    
    // PII-509 - Called by async to pre-load the interstitial
    func preload_secondary_interstitial(plc : String) {
        print("[DEBUG] - BEGIN preload_secondary_interstitial")
        
        secondaryInterstitial = ASInterstitialViewController(forPlacementID: plc, with:self)
        secondaryInterstitial?.keyWords = ["Aer", "Serv"]
        secondaryInterstitial?.locationServicesEnabled = true
        secondaryInterstitial?.userId = "AerServUser"
        secondaryInterstitial?.isPreload = true
        secondaryInterstitial?.loadAd()
    }
    

}

