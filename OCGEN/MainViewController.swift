//
//  FirstViewController.swift
//  OCGEN
//
//  Created by Jason Chiu on 17/05/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import UIKit
import AerServSDK
import DTBiOSSDK        // A9 is slightly different for mediation



class MainViewController: UIViewController, ASAdViewDelegate, DTBAdCallback {
   
    // Get a copy of the VC instance
    var vc = VCInstance.sharedInstance
    var gd = GDPRInstance.sharedInstance
    
    // State Control and other vars
    var isReady = false
    var bannerPlacementID = "380885"
    
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
    

    
    // A9 Specific:
    var isA9Placement = false           // Use this to drive the logic of showing the ad
    var kA9Banner320X50SlotId = "5ab6a4ae-4aa5-43f4-9da4-e30755f2b295"
    var a9BannerResponse: DTBAdResponse?
    var a9BannerAdSize: DTBAdSize?
    var a9BannerLoaded: Bool?
    
    // MARK: - CORE - Core application function
    
    // This function is called to generate an OC. It will take some currency.
    @IBAction func generateOC(_ sender: Any) {
        
        print ("[DEBUG] generateOC - Generating OC..")
        
        if (chargeVC()){
            self.resultOCText.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
            self.spinner.isHidden = true;
            // print ("[DEBUG] generateOC - success!")
        } else {
            // print ("[DEBUG] generateOC - insufficient funds")
        }
        
    }
    
    // This function is called to charge the user's VC account (pulled from storage)
    func chargeVC() -> Bool{
        
        // Verify the transaction is valid, decrement, and then return true
        if (vc.checkAmountIsValid(toCheck: vc.getSpendAmount())) {
            vc.decrementAmount(toTake: vc.getSpendAmount())
            
            // refresh the display
            energyVC?.text = util_createEnergyDisplayText();
            return true
        }
        
        // If not valid, return false and do nothing
        return false
        
    }
    
    
    // MARK: - VIEW - View controller functions
    
    @IBAction func editGDPR(_ sender: Any) {
        gd.setEditMode(toSet: true)
        performSegue(withIdentifier: "ModifyGDPRSettings", sender: sender)
    }
    
    
    
    // On the initial view load, do the following:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare A9 banner response
        self.isA9Placement = false;
        self.a9BannerLoaded = false;
        self.a9BannerResponse = nil;
        self.a9BannerAdSize = DTBAdSize.init(bannerAdSizeWithWidth: 320, height: 50, andSlotUUID: kA9Banner320X50SlotId)
        print ("[DEBUG] viewDidLoad - a9BannerAdSize allocat 320x50")

        
        // Set the UI text elements for this view
        version?.text = util_createSDKVersionDisplayText()
        gdpr?.text = util_createGDPRDisplayText()
        energyVC?.text = util_createEnergyDisplayText();
        
        // Load the banner
        load_banner()
        
    }
    

    
    // Every time the view appears, do the following:
    override func viewWillAppear(_ animated: Bool) {
        
        // Set the energy text using our utility function
        energyVC?.text = util_createEnergyDisplayText()

    }
    
    // Every time the view disappears, do the following:
    override func viewDidDisappear(_ animated: Bool) { }
    
    override func viewDidLayoutSubviews() {
        
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
        
        
        // If this is not an A9 placement, do the normal thing.
        if (!isA9Placement) {
            banner?.frame = CGRect.init(x: xPos, y: yPos, width: CGFloat(ASBannerSize.width), height: CGFloat(ASBannerSize.height))
            banner?.isPreload = true
            banner?.delegate = self
            banner?.sizeAdToFit = true
            banner?.locationServicesEnabled = true
            
            // Add to the subview, unwrap, and then load
            view.addSubview(banner!)
            banner?.loadAd()
        }
        
        // If the A9 banner has not yet been loaded, prepare it for loading in case we get one.
        if (a9BannerLoaded! == false){
            
            // have an array to store the DTBAdResponses from the DTB A9 delegate callback
            banner?.dtbAdResponses = [a9BannerResponse, a9BannerResponse]
            print("[DEBUG - DTBAdCallback] @--- banner?.dtbAdResponses ---@")
            
            var bannerSize = DTBAdSize(bannerAdSizeWithWidth: 320, height: 50, andSlotUUID: kA9Banner320X50SlotId)
            var bannerSizes = [Any]()
            bannerSizes.append(bannerSize ?? nil)
            
            let adLoader = DTBAdLoader()
            adLoader.setAdSizes(bannerSizes)
            adLoader.loadAd(self);          // Load A9
            
            print("[DEBUG - DTBAdCallback] adLoader loadAd ")
        }
        
        // if this is the second time we are load_banner because of a9's delegate
        if (isA9Placement && a9BannerResponse! != nil) {
            print("[DEBUG - DTBAdCallback] damn straight, let's load this thing")
            self.a9BannerLoaded = false;
            
            // have an array to store the DTBAdResponses from the DTB A9 delegate callback
            banner?.dtbAdResponses = [a9BannerResponse, a9BannerResponse]
            banner?.frame = CGRect.init(x: xPos, y: yPos, width: CGFloat(ASBannerSize.width), height: CGFloat(ASBannerSize.height))
            banner?.delegate = self
            
            // Add to the subview, unwrap, and then load
            view.addSubview(banner!)
            banner?.loadAd()
            
            print("[DEBUG - DTBAdCallback] attempted load. do we see anything?")

            
        }
        
        
       

    }
    
    // Dispose of any resources that can be recreated
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    // MARK: - ASAdViewDelegate Dependency -  Required for ASAdViewDelegate
    
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
    
    
    
    // MARK: - UTILS - Utility functions to control strings
    
    // Util for controlling the energy display text
    func util_createEnergyDisplayText() -> String {
        return String(vc.getAmount()) + " " +  vc.getCurrencyName();
    }
    
    // Util for controlling the gdpr display text
    func util_createGDPRDisplayText() -> String {
        return String("GDPR Consent: " + String(AerServSDK.getGDPRConsentValue()))
    }
    
    // Util for controlling the SDK version text
    func util_createSDKVersionDisplayText() -> String {
        return String("SDK Version: " + AerServSDK.sdkVersion())
    }
    
    
    
    
    // MARK: - CALLBACKS - Callback functions we are subscribed to
 
    // In use: when the ad is preloaded - set isReady to true to disable any 'loading' behavior / show the ad.
    func adViewDidPreloadAd(_ adView: ASAdView!) {
        isReady = true
        print("[DEBUG] @--- Banner ad is preloaded ---@")
    }
    
    // Not used: when the ad is loaded (not preloaded)
    func adViewDidLoadAd(_ adView: ASAdView!) {
        print("[DEBUG] @--- Banner ad was loaded ---@")
    }
    
    // Not used:
    func willPresentModalView(forAd adView: ASAdView!) {
        print("[DEBUG] @--- Banner will presented modal ---@")
    }
    
    // Not used: when the ad is clicked, register some behavior
    func adWasClicked(_ adView: ASAdView!) {
        print("[DEBUG] @--- Banner ad was clicked ---@")
    }
    
    // Not used: when the ad fails to load / preload, register some behavior
    func adViewDidFail(toLoadAd adView: ASAdView!, withError error: Error!) {
        print("[DEBUG] @--- Banner ad failed: ", error, " ---@")
    }
    
    // Not used:
    func willLeaveApplicaton(fromAd adView: ASAdView!) {
        //print("[DEBUG] @--- Banner ad left application ---@")
    }
    
    // Not used:
    func adSizedChanged(_ adView: ASAdView!) {
        //print("[DEBUG] @--- Banner ad sized changed ---@")
    }
    
    // Not used: when a VAST ad finishes, register some behavior
    func adViewDidCompletePlaying(withVastAd adView: ASAdView!) {
        //print("[DEBUG] @--- Banner ad completed playing vast ---@")
    }
    
    // Not used: when an ad does show, register some behavior
    func adView(_ adView: ASAdView!, didShowAdWithTransactionInfo transcationData: [AnyHashable : Any]!) {
        //print("[DEBUG] @--- Banner ad has transaction info: buyerName = ", transcationData["buyerName"] ?? "nil", ", buyerPrice = ",  transcationData["buyerPrice"] ?? "nil", " ---@")
    }
    
    // Not used:
    func didDismissModalView(forAd adView: ASAdView!) {
        //print("[DEBUG] @--- Banner ad did dismissed modal ---@")
    }

    // MARK: - A9 CALLBACKS - DTBAdCallback
    
    func onFailure(_ error: DTBAdError) {
        print("[DEBUG - DTBAdCallback] onFailure")
        self.a9BannerResponse = nil;
        self.a9BannerLoaded = false;
    }
    
    func onSuccess(_ adResponse: DTBAdResponse!) {
        print("[DEBUG - DTBAdCallback] onSuccess")
        
        if(adResponse.adSizes() != nil && adResponse.adSizes().count > 0) {
            
            let responseSize:Any? = (adResponse.adSizes())[0]
            if let size = responseSize {
                var adResponseSize = size as! DTBAdSize
                
                // Match up the slot UUID
                if(adResponseSize.slotUUID == self.a9BannerAdSize?.slotUUID){
                    print("[DEBUG - DTBAdCallback] match: " + adResponseSize.slotUUID)
                    self.a9BannerResponse = adResponse
                    self.a9BannerLoaded = true
                    
                    print("[DEBUG - DTBAdCallback] calling load banner again!")
                    isA9Placement = true        // set this to true so that we properly try to load the banner
                    load_banner()
                }

            }

        
        }
        
    }

}

