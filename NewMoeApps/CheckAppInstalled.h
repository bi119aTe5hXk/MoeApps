//
//  CheckAppInstalled.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 14-1-24.
//  Copyright (c) 2014年 HT&L. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CheckAppInstalled;
@protocol CheckAppInstalledDelegate
@optional
- (void)CheckApp:(CheckAppInstalled *)app isInstalled:(BOOL)installed;

@end
@interface CheckAppInstalled : NSObject<NSURLConnectionDelegate>{
    
}
-(CheckAppInstalled *)initWithdelegate:(NSObject <CheckAppInstalledDelegate> *)delegate;
-(void)checkappinstalledWithAppID:(NSString *)appid;
-(void)checkappinstalledWithBundleID:(NSString *)bundleid;
-(void)cancelRequest;
@end
