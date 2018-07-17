//
//  SecondViewController.swift
//  OCGEN
//
//  Created by Jason Chiu on 17/05/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import UIKit
import AerServSDK
import DTBiOSSDK        // A9 is slightly different for mediation


class EarningViewController: UIViewController, ASInterstitialViewControllerDelegate, DTBAdCallback {

    
    // Get a singleton VC instance
    var vc = VCInstance.sharedInstance
    
    // State Control and other vars
    var interstitialPlacementID = "380889"
    var supportA9 = true                    // Variable that controls whether this app makes the S2S connection to A9
    var isPreloading = false
    var preloadReady = false
    
    // Banner and interstitial objects
    var interstitial: ASInterstitialViewController?

    // Declare my view variables here
    @IBOutlet weak var earnEnergyVC: UILabel!
    @IBOutlet weak var showInterstitial: UIButton!
    @IBOutlet weak var adLoadSpinner: UIActivityIndicatorView!
    
    // A9 Configurations:
    var a9InterstitialResponse: DTBAdResponse?
    var a9InterstitialAdSize: DTBAdSize?
    
    var a9InterstitialLoaded = false;
    var kA9InterstitialSlotId = "4e918ac0-5c68-4fe1-8d26-4e76e8f74831"
    
    
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
    
            // if A9 mediation is supported, load A9 first so it can participate in the auction afterwards
            if (supportA9) {
                load_interstitial_a9()
            }
                // Otherwise, just load the banner as we do normally
            else {
                // Preload the interstitial
                preload_interstitial(plc: interstitialPlacementID)
            }
            
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
    
    
    func load_interstitial_a9(){
        
        // Prepare A9 banner response
        a9InterstitialLoaded = false;                        // Set the a9BannerLoaded to false when viewDidLoad. When we get the delegate callback from A9, we will then set this to true.
        a9InterstitialResponse = nil;                        // Clear out the last response. TODO: Need to make a new a9Response when the previous banner is 'refreshed'
        
        var interstitialSize = [DTBAdSize]()
        interstitialSize.append(DTBAdSize(interstitialAdSizeWithSlotUUID: kA9InterstitialSlotId))
        
        let adLoader = DTBAdLoader()
        adLoader.setAdSizes(interstitialSize)
        adLoader.loadAd(self);
        
        print ("[DEBUG] viewDidLoad - DTBAdSize interstitialSize")
        
    }
    
    // Called by the initial and the viewWillAppear to pre-load the interstitial
    func preload_interstitial(plc : String) {
        
        if (!a9InterstitialLoaded && !isPreloading){
            isPreloading = true
            print("[DEBUG] - BEGIN preload_interstitial")
            interstitial = ASInterstitialViewController(forPlacementID: plc, with:self)
            interstitial?.locationServicesEnabled = true
            interstitial?.userId = "AerServUser"
            interstitial?.isPreload = true
            interstitial?.loadAd()
        }
            
        if (a9InterstitialLoaded && a9InterstitialResponse != nil) {
            
            isPreloading = true
            
            interstitial = ASInterstitialViewController(forPlacementID: plc, with:self)
            interstitial?.locationServicesEnabled = true
            interstitial?.userId = "AerServUser"

            print("[DEBUG] preload_interstitial hasResponse a9InterstitialResponse")
            a9InterstitialLoaded = false;
            // Create an array to store the DTBAdResponses from the DTB A9 delegate callback
            interstitial?.dtbAdResponses = [a9InterstitialResponse as Any, a9InterstitialResponse as Any]
            interstitial?.delegate = self
            interstitial?.isPreload = true
            interstitial?.loadAd()
            
            print("[DEBUG] preload_interstitial is ready, a9InterstitialLoaded")
        }
            
            
            
        else {
        print("[DEBUG] - preloading_interstitial")
        }
        
 
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
    

    
    
    // MARK: - A9 CALLBACKS - DTBAdCallback

    
    func onFailure(_ error: DTBAdError) {
        print("[DEBUG] DTBAdCallback onFailure")
        a9InterstitialResponse = nil;         // Ensure the response is still set to nil
        a9InterstitialLoaded = false;         // Ensure that a9BannerLoader is set to false so we do not try to run the a9 logic in the show
    }
    
    func onSuccess(_ adResponse: DTBAdResponse!) {
        print("[DEBUG] DTBAdCallback onSuccess")
        
        
        if(adResponse.adSizes() != nil && adResponse.adSizes().count > 0) {
            
            let adResponseSize = (adResponse.adSizes())[0] as! DTBAdSize
            a9InterstitialLoaded = true
            a9InterstitialResponse = adResponse
            print("[DEBUG - DTBAdCallback] calling preload_interstitial on interstitialPlacementID!")
            preload_interstitial(plc: interstitialPlacementID)

            
            // Match up the slot UUID
            if(adResponseSize.slotUUID == self.a9InterstitialAdSize?.slotUUID){
                a9InterstitialLoaded = true
                
 
                
            }
        
            
        }
        

        
    }
    

}

