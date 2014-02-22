//
//  TabBarViewController.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-12-17.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarViewController : UITabBarController<GADBannerViewDelegate,GADInterstitialDelegate>{
    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;
}

@end
