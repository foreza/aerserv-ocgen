//
//  FirstViewController.swift
//  OCGEN
//
//  Created by Jason Chiu on 17/05/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import UIKit
import AerServSDK


class FirstViewController: UIViewController, ASInterstitialViewControllerDelegate, ASAdViewDelegate {

    

    // State Control and other vars
    var isReady = false
    var bannerPlacementID = "380000"
    
    // Banner and interstitial objects
    var banner: ASAdView?

    
    // Declare my view variables here
    
    
    
    
    // On View load, do the following
    /*
 
 
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
   

        
        load_banner();

    }
    
    
    override func viewWillAppear(_ animated: Bool) { }
    
    override func viewDidDisappear(_ animated: Bool) { }
    
    override func viewDidLayoutSubviews() {
        
        // hiding version label in landscape
//        version?.isHidden = !UIDeviceOrientationIsPortrait(UIDevice.current.orientation)
        
        // position banner at the bottome of screen for both portrait & landscape
        
        let navigationBarHeight: CGFloat = self.tabBarController!.tabBar.frame.height
        
        if(banner != nil) {
            let viewWidth = view.frame.size.width
            let viewHeight = view.frame.size.height
            let xPos = (viewWidth - ASBannerSize.width)/2
            let yPos = viewHeight - (ASBannerSize.height + navigationBarHeight)
            banner?.frame = CGRect.init(x: xPos, y: yPos, width: ASBannerSize.width, height: ASBannerSize.height)
        }
    }
    
    // Loads the banner
    func load_banner() {
        
        // If the banner is already existing, kill it
        if(banner != nil) {
            self.banner?.cancel()
            banner?.removeFromSuperview()
            banner = nil
        }

        // Configure the banner here
        banner = ASAdView(placementID: bannerPlacementID, andAdSize: ASBannerSize)
        
        let viewWidth:CGFloat = view.frame.size.width
        let viewHeight:CGFloat = view.frame.size.height
        let xPos:CGFloat = (viewWidth - (ASBannerSize.width))/2
        let yPos:CGFloat = viewHeight - (ASBannerSize.height)
        banner?.frame = CGRect.init(x: xPos, y: yPos, width: CGFloat(ASBannerSize.width), height: CGFloat(ASBannerSize.height))
        banner?.delegate = self
        banner?.sizeAdToFit = true;
        banner?.locationServicesEnabled = true
        banner?.keyWords = ["Aer", "Serv"]
        banner?.sizeAdToFit = true;
        
        print("[DEBUG] xPos is \(xPos) and yPos is \(yPos) for the display")
        
        // Add to the subview, unwrap, and then load
        view.addSubview(banner!)
        banner?.loadAd()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Required for ASAdViewDelegate
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    
    //MARK: ASInterstitialViewController Delegate callback
    func interstitialViewControllerDidPreloadAd(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad preload ready ---@");
        isReady = true;
    }
    
    func interstitialViewControllerAdLoadedSuccessfully(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad loaded ---@")
    }
    
    func interstitialViewController(_ viewController: ASInterstitialViewController!, didShowAdWithTransactionInfo transcationData: [AnyHashable : Any]!) {
        print("@--- Interstitial ad has transaction info: buyerName = ", transcationData["buyerName"] ?? "nil", ", buyerPrice = ",  transcationData["buyerPrice"] ?? "nil", " ---@")
    }
    
    func interstitialViewControllerDidVirtualCurrencyLoad(_ viewController: ASInterstitialViewController!, vcData: [AnyHashable : Any]!) {
        print("@--- Interstitial ad with virtual currency rewarded: name =", vcData["name"] ?? "nil", ", rewardAmount =", vcData["rewardAmount"] ?? "nil", ", buyerName =", vcData["buyerName"] ?? "nil", ", buyerPrice =",  vcData["buyerPrice"] ?? "nil", " ---@")
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
    
    func interstitialViewControllerDidVirtualCurrencyReward(_ viewController: ASInterstitialViewController!, vcData: [AnyHashable : Any]!) {
        print("@--- Interstitial ad did reward virtual curreny: name =", vcData["name"] ?? "nil", ", rewardAmount =", vcData["rewardAmount"] ?? "nil", "buyerName =", vcData["buyerName"] ?? "nil", ", buyerPrice =",  vcData["buyerPrice"] ?? "nil", " ---@")
    }
    
    func interstitialViewControllerWillDisappear(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad will disappear ---@")
    }
    
    func interstitialViewControllerDidDisappear(_ viewController: ASInterstitialViewController!) {
        print("@--- Interstitial ad did disappear ---@")
    }
    
    func adViewDidPreloadAd(_ adView: ASAdView!) {
        isReady = true
        print("@--- Banner ad is preloaded ---@")
    }
    
    func adViewDidLoadAd(_ adView: ASAdView!) {
        print("@--- Banner ad was loaded ---@")
    }
    
    func willPresentModalView(forAd adView: ASAdView!) {
        print("@--- Banner will presented modal ---@")
    }
    
    func adWasClicked(_ adView: ASAdView!) {
        print("@--- Banner ad was clicked ---@")
    }
    
    func adViewDidFail(toLoadAd adView: ASAdView!, withError error: Error!) {
        print("@--- Banner ad failed: ", error, " ---@")
    }
    
    func willLeaveApplicaton(fromAd adView: ASAdView!) {
        print("@--- Banner ad left application ---@")
    }
    
    func adSizedChanged(_ adView: ASAdView!) {
        print("@--- Banner ad sized changed ---@")
    }
    
    func adViewDidCompletePlaying(withVastAd adView: ASAdView!) {
        print("@--- Banner ad completed playing vast ---@")
    }
    
    func adView(_ adView: ASAdView!, didShowAdWithTransactionInfo transcationData: [AnyHashable : Any]!) {
        print("@--- Banner ad has transaction info: buyerName = ", transcationData["buyerName"] ?? "nil", ", buyerPrice = ",  transcationData["buyerPrice"] ?? "nil", " ---@")
    }
    
    func didDismissModalView(forAd adView: ASAdView!) {
        print("@--- Banner ad did dismissed modal ---@")
    }


}

