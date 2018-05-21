//
//  SecondViewController.swift
//  OCGEN
//
//  Created by Jason Chiu on 17/05/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import UIKit
import AerServSDK



class SecondViewController: UIViewController, ASInterstitialViewControllerDelegate {

    var vc = VCInstance.sharedInstance
    
    // State Control and other vars
    var isReady = false
    var interstitialPlacementID = "380004"
    
    // Banner and interstitial objects
    var interstitial: ASInterstitialViewController?
    
    // Declare my view variables here
    @IBOutlet weak var earnEnergyVC: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        earnEnergyVC?.text = String(vc.getAmount()) + " " +  vc.getCurrencyName();

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        earnEnergyVC?.text = String(vc.getAmount()) + " " +  vc.getCurrencyName();

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Load Interstitial
    @IBAction func load_interstitial(_ sender: Any) {
        
        interstitial = ASInterstitialViewController(forPlacementID: interstitialPlacementID, with:self)
        interstitial?.keyWords = ["Aer", "Serv"]
        interstitial?.locationServicesEnabled = true
        interstitial?.userId = "AerServUser"
        //        interstitial?.isPreload = (preload_switch?.isOn)!
        interstitial?.loadAd()
    }
    
    
    // CALL BACK METHODS FOR INTERSTITIALS
    
    
    func interstitialViewControllerDidVirtualCurrencyLoad(_ viewController: ASInterstitialViewController!, vcData: [AnyHashable : Any]!) {
        print("@--- Interstitial ad with virtual currency rewarded: name =", vcData["name"] ?? "nil", ", rewardAmount =", vcData["rewardAmount"] ?? "nil", ", buyerName =", vcData["buyerName"] ?? "nil", ", buyerPrice =",  vcData["buyerPrice"] ?? "nil", " ---@")
    }
    
    func interstitialViewControllerDidVirtualCurrencyReward(_ viewController: ASInterstitialViewController!, vcData: [AnyHashable : Any]!) {
        print("@--- Interstitial ad did reward virtual curreny: name =", vcData["name"] ?? "nil", ", rewardAmount =", vcData["rewardAmount"] ?? "nil", "buyerName =", vcData["buyerName"] ?? "nil", ", buyerPrice =",  vcData["buyerPrice"] ?? "nil", " ---@")
        
        if let result = vcData["rewardAmount"] as? Int {
            vc.incrementAmount(toAdd: result)
        }
    }
    
    //MARK: ASInterstitialViewController Delegate callback
    func interstitialViewControllerDidPreloadAd(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad preload ready ---@");
        isReady = true;
    }
    
    func interstitialViewControllerAdLoadedSuccessfully(_ viewController: ASInterstitialViewController!) {
        print("[DEBUG]@--- Interstitial ad loaded ---@")
        interstitial?.show(from: self)
    }
    
    func interstitialViewController(_ viewController: ASInterstitialViewController!, didShowAdWithTransactionInfo transcationData: [AnyHashable : Any]!) {
        print("@--- Interstitial ad has transaction info: buyerName = ", transcationData["buyerName"] ?? "nil", ", buyerPrice = ",  transcationData["buyerPrice"] ?? "nil", " ---@")
    }
    

    
    func interstitialViewControllerWillAppear(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad will appear ---@")
    }
    
    func interstitialViewControllerDidAppear(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad did appear ---@")
    }
    
    func interstitialViewControllerAdWasTouched(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad was clicked ---@")
    }
    
    func interstitialViewControllerAdInteraction(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad has interaction ---@")
    }
    
    func interstitialViewControllerAdFailed(toLoad viewController: ASInterstitialViewController!, withError error: Error!) {
        print("@--- Interstitial ad failed: ", error, " ---@")
    }
    
    func interstitialViewControllerAdDidComplete(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad was completed ---@")
    }
    

    
    func interstitialViewControllerWillDisappear(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad will disappear ---@")
    }
    
    func interstitialViewControllerDidDisappear(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad did disappear ---@")
    }
    


}

