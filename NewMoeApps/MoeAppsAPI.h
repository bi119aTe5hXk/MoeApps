//
//  MoeAppsAPI.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-2-2.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "GTMOAuthViewControllerTouch.h"
@class MoeAppsAPI;
@protocol MoeAppsAPIDelegate
@optional
- (void)api:(MoeAppsAPI *)api readyWithList:(NSArray *)list;
- (void)api:(MoeAppsAPI *)api requestFailedWithError:(NSError *)error;
@end
@interface MoeAppsAPI : NSObject<AVAudioPlayerDelegate>{
    NSString *devicetype;
    NSString *languagecode;
}
@property (nonatomic, strong) AVAudioPlayer *audio;
@property(nonatomic, retain) NSUserDefaults *userdefault;
@property(nonatomic) BOOL isVoiceEnabled;
-(MoeAppsAPI *)initWithdelegate:(NSObject <MoeAppsAPIDelegate> *)delegate;
-(void)appinitwithVersion:(NSString *)version WithPushToken:(NSString *)token;

-(void)loadNewestAppListWithType:(NSInteger)type WithPage:(NSInteger)page WithCategory:(NSString *)category;
-(void)loadCategoryList;
-(void)SearchWithKeyword:(NSString *)keyword WithPage:(NSInteger)page WithType:(NSInteger)type;

-(void)getAppDetailwithAppID:(NSString *)app_id;


- (void)cancelConnection;

@end
