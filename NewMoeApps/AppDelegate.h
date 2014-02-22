//
//  AppDelegate.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-1-27.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewViewController.h"
#import "CategoryListViewController.h"
#import "SearchViewController.h"
#import "MoreViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,AVAudioPlayerDelegate,MoeAppsAPIDelegate,UIAlertViewDelegate>{
    NSUserDefaults *userdefault;
    MoeAppsAPI *moeapi;
    NSString *updateurl;
    BOOL isVoiceEnable;
    BOOL needshowmsg;
    BOOL isFirstTimeRun;
}
@property (nonatomic, strong) AVAudioPlayer *audio;
@property (strong, nonatomic) UIWindow *window;


-(void)registerpush;
@end
