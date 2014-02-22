//
//  TabBarViewController.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-12-17.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "TabBarViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    UITabBarItem *item1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostRecent tag:0];
//    UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Category",@"") image:[UIImage imageNamed:@"icon.png"] tag:1];
//    UITabBarItem *item3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:2];
//    [self.tabBar setItems:[NSArray arrayWithObjects:item1,item2,item3, nil] animated:YES];
    
    //NSLog(@"hey!");
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [self loadAdmobAdView];
    }
    
    for (UITabBarItem *tabBarItem in [self.tabBar items]){
        NSInteger tag = tabBarItem.tag;
        switch(tag){
            case 0:
                
                break;
            case 1:
                [tabBarItem setTitle:NSLocalizedString(@"Category",@"")];
                [tabBarItem setImage:[UIImage imageNamed:@"UITabBarStar.png"]];
                break;
            case 2:
                
                break;
        }
    }
}

-(void)loadAdmobAdView{
    [bannerView_ removeFromSuperview];
    bannerView_ = nil;
    CGPoint origin = CGPointMake(0.0,self.view.frame.size.height + 50 - CGSizeFromGADAdSize(kGADAdSizeBanner).height);
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner origin:origin];
    //bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_.adUnitID = @"a152b18c3368568";
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    [bannerView_ setDelegate:self];
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,nil];
    [bannerView_ loadRequest:request];
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    //NSLog(@"didFailToReceiveAdmobWithError%@", [error localizedDescription]);
    //[self loadiAdView];
    [self loadAdmobAdView];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    //NSLog(@"Ad loaded");
    //[UIView beginAnimations:@"BannerSlide" context:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        bannerView.frame = CGRectMake(0.0,
                                      self.view.frame.size.height -
                                      bannerView.frame.size.height - 50,
                                      bannerView.frame.size.width,
                                      bannerView.frame.size.height);
    }else{
        bannerView.frame = CGRectMake(0.0,
                                      self.view.frame.size.height -
                                      bannerView.frame.size.height - 50,
                                      bannerView.frame.size.width,
                                      bannerView.frame.size.height);
    }
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
