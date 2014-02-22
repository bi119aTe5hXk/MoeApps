//
//  DetailViewController_iPad.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-12-5.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "iHasApp.h"
#import "CheckAppInstalled.h"
#import "GADBannerView.h"
#import "GADInterstitial.h"
@interface DetailViewController_iPad : UIViewController<MoeAppsAPIDelegate,SKStoreProductViewControllerDelegate,UIActionSheetDelegate,UISplitViewControllerDelegate,GADBannerViewDelegate,GADInterstitialDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate,CheckAppInstalledDelegate>{
    
    GADBannerView *bannerView_;
    GADInterstitial *interstitial_;
    MoeAppsAPI *moeapi;
    CheckAppInstalled *checkapp;
    UIImageView *img;
}
@property(nonatomic, retain) NSUserDefaults *userdefault;
@property(nonatomic) BOOL isVoiceEnabled;

@property (strong, nonatomic) id detailItem;
@property (nonatomic,retain) NSArray *appdetailarray;

@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;
@property (nonatomic, retain) IBOutlet UIScrollView *preveiwscroll;
@property (nonatomic, retain) IBOutlet UIImageView *appicon;
@property (nonatomic, retain) IBOutlet UILabel *apptitle;
@property (nonatomic, retain) IBOutlet UILabel *company;
@property (nonatomic,retain) IBOutlet UILabel *size;
@property (nonatomic,retain) IBOutlet UILabel *category;
@property (nonatomic, retain) IBOutlet UIButton *storebtn;
//@property (nonatomic, retain) IBOutlet UIButton *tuibtn;
@property (nonatomic, retain) IBOutlet UITextView *description;

-(IBAction)appstorebtnpressd:(id)sender;
-(IBAction)viewinTongbuTui:(id)sender;

@property (nonatomic, retain) IBOutlet UILabel *inittitle;
@property (nonatomic, retain) IBOutlet UIView *initview;

@property (nonatomic, strong) AVAudioPlayer *audio;
-(IBAction)touchx:(id)sender;
-(IBAction)touchhead:(id)sender;
-(IBAction)touchtail1:(id)sender;
-(IBAction)touchtail2:(id)sender;
-(IBAction)touchtail3:(id)sender;
-(IBAction)touchLear:(id)sender;
-(IBAction)touchRear:(id)sender;
-(IBAction)touchLhend:(id)sender;
-(IBAction)touchRhend:(id)sender;
-(IBAction)touchLleg:(id)sender;
-(IBAction)touchRleg:(id)sender;
-(IBAction)touchmouth:(id)sender;
-(IBAction)touchLface:(id)sender;
-(IBAction)touchRface:(id)sender;
@end
