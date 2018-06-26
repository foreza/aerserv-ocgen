//
//  MonsterViewController.swift
//  OCGEN
//
//  Created by Jason C on 6/25/18.
//  Copyright © 2018 Vartyr. All rights reserved.
//

import UIKit
import AerServSDK
import QuartzCore       // Required for CADisplayLink



class MonsterViewController: UIViewController, ASAdViewDelegate {
    
    // Banner and interstitial objects
    var bannerPlacementID = "1028254" // PII-523 Placement
    var banner: ASAdView?
    
    // Instance of CADisplayLink to let us draw
    var displayLink : CADisplayLink?
    
    // Monsters!
    var monster = Monster();
    
    // Todo: Couple this instead with the Monster.swift class so when we make a monster we make an image view
    @IBOutlet weak var MonsterSprite: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load a banner
        load_banner();
        
        // MONSTER roar on init
        monster.roar();
        
        // Set up our game loop
        let displaylink = CADisplayLink(target: self, selector: #selector(step))
        displaylink.add(to: .current, forMode: .defaultRunLoopMode)
        
        // Set up our gesture recognizers
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.view.addGestureRecognizer(tap)

    }
    
    
    
    
    // Recenter the sprite when a tap is heard in case our monster escapes
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello World")
        monster.roar();
        monster.setPosition(x: (self.view.frame.width - MonsterSprite.frame.width)/2, y: (self.view.frame.height - MonsterSprite.frame.height)/2)
    }
    
    // Called by the game loop update
    @objc func step(displaylink: CADisplayLink) {
        print(displaylink.timestamp)
        
        // Update will select a random direction
        monster.update(deltaTime: 1.0);
        
        // Draw the updated location of the monster TODO: IMPROVE THIS AND REFACTOR THIS INTO A CLASS FUNCTION
        MonsterSprite.frame.origin.x = monster.getPosX();
        MonsterSprite.frame.origin.y = monster.getPosY();

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Loads a banner
    func load_banner() {
        
        // If the banner is already existing, kill it
        if(banner != nil) {
            self.banner?.cancel()
            banner?.removeFromSuperview()
            banner = nil
        }
        
        // Configure the banner here
        banner = ASAdView(placementID: bannerPlacementID, andAdSize: ASBannerSize)
        
        let viewWidth:CGFloat = view.frame.size.width               // Get the view Width
        let viewHeight:CGFloat = view.frame.size.height             // Get the view Height
        let xPos:CGFloat = (viewWidth - (ASBannerSize.width))/2     // The xPos is (viewWidth - 320)/2
        let yPos:CGFloat = viewHeight - (ASBannerSize.height)       // The yPos is viewHeight - 50
        
        banner?.frame = CGRect.init(x: xPos, y: yPos, width: CGFloat(ASBannerSize.width), height: CGFloat(ASBannerSize.height))
        
    
        // Ensure we are listening to the delegate callback functions
        banner?.delegate = self
        banner?.sizeAdToFit = true;
        banner?.locationServicesEnabled = true;
        banner?.bannerRefreshTimeInterval = 20.0;        // PII-523 set refresh interval
        banner?.sizeAdToFit = true;
        
        print("[DEBUG] load_banner - xPos is \(xPos) and yPos is \(yPos) for the display")
        
        // Add to the subview, unwrap, and then load
        self.view.addSubview(banner!)
        banner?.loadAd()
        
    }
    
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }
    
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
    
    func adViewDidPreloadAd(_ adView: ASAdView!) {
        //print("[DEBUG] @--- Banner ad is preloaded ---@")
    }

    

}
