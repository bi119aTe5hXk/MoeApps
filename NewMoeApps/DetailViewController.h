//
//  DetailViewController.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-8-3.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iHasApp.h"
#import "CheckAppInstalled.h"
#import <StoreKit/StoreKit.h>
@interface DetailViewController : UIViewController<MoeAppsAPIDelegate,SKStoreProductViewControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,CheckAppInstalledDelegate>{
    MoeAppsAPI *moeapi;
    CheckAppInstalled *checkapp;
}

@property (nonatomic, retain) NSString *appid;
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

@end
