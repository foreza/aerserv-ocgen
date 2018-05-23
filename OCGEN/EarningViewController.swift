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

    var vc = VCInstance.sharedInstance
    
    // State Control and other vars
    var interstitialPlacementID = "380004"
    var preloadReady = false
    
    // Banner and interstitial objects
    var interstitial: ASInterstitialViewController?
    
    // Declare my view variables here
    @IBOutlet weak var earnEnergyVC: UILabel!
    @IBOutlet weak var showInterstitial: UIButton!
    @IBOutlet weak var adLoadSpinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // Preload the interstitial
        preload_interstitial()
        
        // Set all text elements
        earnEnergyVC?.text = String(vc.getAmount()) + " " +  vc.getCurrencyName();
        
        // Set all view elements
        showInterstitial?.isHidden = true;
        adLoadSpinner?.isHidden = false;
        adLoadSpinner?.startAnimating();

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        if (!preloadReady) {
            // Preload the interstitial
            preload_interstitial()
            
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
    
    // Pre-load interstitial
    func preload_interstitial() {
        
        interstitial = ASInterstitialViewController(forPlacementID: interstitialPlacementID, with:self)
        interstitial?.keyWords = ["Aer", "Serv"]
        interstitial?.locationServicesEnabled = true
        interstitial?.userId = "AerServUser"
        interstitial?.isPreload = true
        interstitial?.loadAd()
    }
    
    @IBAction func show_interstitial() {
        interstitial?.show(from: self)
        preloadReady = false
    }

    
    
    // CALL BACK METHODS FOR INTERSTITIALS
    
    
    func interstitialViewControllerDidVirtualCurrencyLoad(_ viewController: ASInterstitialViewController!, vcData: [AnyHashable : Any]!) {
        print("[DEBUG] @--- Interstitial ad with virtual currency rewarded: name =", vcData["name"] ?? "nil", ", rewardAmount =", vcData["rewardAmount"] ?? "nil", ", buyerName =", vcData["buyerName"] ?? "nil", ", buyerPrice =",  vcData["buyerPrice"] ?? "nil", " ---@")
    }
    
    func interstitialViewControllerDidVirtualCurrencyReward(_ viewController: ASInterstitialViewController!, vcData: [AnyHashable : Any]!) {
        print("[DEBUG] @--- Interstitial ad did reward virtual curreny: name =", vcData["name"] ?? "nil", ", rewardAmount =", vcData["rewardAmount"] ?? "nil", "buyerName =", vcData["buyerName"] ?? "nil", ", buyerPrice =",  vcData["buyerPrice"] ?? "nil", " ---@")
        
        if let result = vcData["rewardAmount"] as? Int {
            vc.incrementAmount(toAdd: result)
        }
    }
    
    //MARK: ASInterstitialViewController Delegate callback
    func interstitialViewControllerDidPreloadAd(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG] @--- Interstitial ad preload ready ---@");
        showInterstitial?.isHidden = false
        adLoadSpinner.stopAnimating()
        adLoadSpinner.isHidden = true
        preloadReady = true
    }
    
//    func interstitialViewControllerAdLoadedSuccessfully(_ viewController: ASInterstitialViewController!) {
//        print("[DEBUG] @--- Interstitial ad loaded ---@")
//        interstitial?.show(from: self)
//    }
    
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
    


}

