//
//  FirstViewController.swift
//  OCGEN
//
//  Created by Jason Chiu on 17/05/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import UIKit
import AerServSDK


class FirstViewController: UIViewController, ASAdViewDelegate {
   
    // Get a copy of the VC instance
    var vc = VCInstance.sharedInstance
    
    // State Control and other vars
    var isReady = false
    var bannerPlacementID = "380000"
    
    // Banner and interstitial objects
    var banner: ASAdView?
    
    // Declare my view variables here
    
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var gdpr: UILabel!
    @IBOutlet weak var energyVC: UILabel!
    
    @IBOutlet weak var generateOCButton: UIButton!
    @IBOutlet weak var resultOCText: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    

    
    // On View load, do the following
    /*
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the UI text elements for this view.
        version?.text = String("SDK Version: " + AerServSDK.sdkVersion())
        gdpr?.text = String("GDPR Consent: " + String(AerServSDK.getGDPRConsentValue()))
        energyVC?.text = String(vc.getAmount()) + " " +  vc.getCurrencyName();

        load_banner()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
    
        
        energyVC?.text = String(vc.getAmount()) + " " +  vc.getCurrencyName();

    }
    
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
    
    
    
    // FUNCTION TO DO SOMETHING TO GENERATE OC
    @IBAction func generateOC(_ sender: Any) {
        print ("[DEBUG] generating OC..")
            self.resultOCText.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
        self.spinner.isHidden = true;
    
        
    }
    

    
 
    func adViewDidPreloadAd(_ adView: ASAdView!) {
        isReady = true
        print("[DEBUG] @--- Banner ad is preloaded ---@")
    }
    
    func adViewDidLoadAd(_ adView: ASAdView!) {
        print("[DEBUG] @--- Banner ad was loaded ---@")
    }
    
    func willPresentModalView(forAd adView: ASAdView!) {
        print("[DEBUG] @--- Banner will presented modal ---@")
    }
    
    func adWasClicked(_ adView: ASAdView!) {
        print("[DEBUG] @--- Banner ad was clicked ---@")
    }
    
    func adViewDidFail(toLoadAd adView: ASAdView!, withError error: Error!) {
        print("[DEBUG] @--- Banner ad failed: ", error, " ---@")
    }
    
    func willLeaveApplicaton(fromAd adView: ASAdView!) {
        print("[DEBUG] @--- Banner ad left application ---@")
    }
    
    func adSizedChanged(_ adView: ASAdView!) {
        print("[DEBUG] @--- Banner ad sized changed ---@")
    }
    
    func adViewDidCompletePlaying(withVastAd adView: ASAdView!) {
        print("[DEBUG] @--- Banner ad completed playing vast ---@")
    }
    
    func adView(_ adView: ASAdView!, didShowAdWithTransactionInfo transcationData: [AnyHashable : Any]!) {
        print("[DEBUG] @--- Banner ad has transaction info: buyerName = ", transcationData["buyerName"] ?? "nil", ", buyerPrice = ",  transcationData["buyerPrice"] ?? "nil", " ---@")
    }
    
    func didDismissModalView(forAd adView: ASAdView!) {
        print("[DEBUG] @--- Banner ad did dismissed modal ---@")
    }


}

