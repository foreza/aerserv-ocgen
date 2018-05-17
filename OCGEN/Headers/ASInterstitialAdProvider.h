//
//  ASAdProvider.h
//  AerServSDK
//
//  Copyright (c) 2014 AerServ, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ASAdProvider.h"

/*! @header
 * Class that must be impletented to provide interstitial ads to AerServ. */

@protocol ASInterstitialAdProviderDelegate;

@interface ASInterstitialAdProvider : ASAdProvider

@property (nonatomic, weak) id<ASInterstitialAdProviderDelegate> delegate;

- (void)requestInterstitialAd;
- (void)requestMediationInterstitialAdWithCredentials:(NSDictionary*)cred;
- (BOOL)canShowInterstitialFromRootViewController:(UIViewController*)rootViewController;
- (void)failShowInterstitialViewController;
- (void)showInterstitialFromRootViewController:(UIViewController*)rootViewController;
- (void)putAdIntoProvider;

@end

/* Delegate calls that the interstitial ad provider must call. */
@protocol ASInterstitialAdProviderDelegate <NSObject>

- (void)interstitialAdProvider:(ASInterstitialAdProvider*)provider didLoadAd:(id)ad;
- (void)interstitialAdProvider:(ASInterstitialAdProvider*)provider didFailToLoadAdWithError:(NSError*)error;
- (void)interstitialAdProvider:(ASInterstitialAdProvider*)provider didPreloadAd:(id)ad;
- (void)interstitialAdProviderDidAdComplete:(ASInterstitialAdProvider*)provider;

- (void)interstitialAdProvider:(ASInterstitialAdProvider*)provider didVirtualCurrencyLoad:(NSDictionary*)vcData;
- (void)interstitialAdProvider:(ASInterstitialAdProvider*)provider didVirtualCurrencyReward:(NSDictionary*)vcData;

- (void)interstitialAdProviderWillAppear:(ASInterstitialAdProvider*)provider;
- (void)interstitialAdProviderDidAppear:(ASInterstitialAdProvider*)provider;

- (void)interstitialAdProviderWillDisappear:(ASInterstitialAdProvider*)provider;
- (void)interstitialAdProviderDidDisappear:(ASInterstitialAdProvider*)provider;

- (void)interstitialAdProviderAdWasTouched:(ASInterstitialAdProvider*)provider;
- (void)interstitialAdProviderAdInteraction:(ASInterstitialAdProvider*)provider;

- (void)interstitialAdProviderWillFireFailShow:(ASInterstitialAdProvider*)provider;

- (void)interstitialAdProvider:(ASInterstitialAdProvider*)provider didFireAdvertiserEventWithMessage:(NSString*)msg;

@end
