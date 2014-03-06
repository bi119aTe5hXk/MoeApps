//
//  AppDelegate.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-1-27.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//
#import "AppDelegate.h"
@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    application.statusBarHidden = NO;
    NSLog(@"Powered by");
    NSLog(@" __   __              __            ");
    NSLog(@"|  ＼／  |           ／ _|           ");
    NSLog(@"| ＼  ／ | ___   ___| |_ ___  __  __ ");
    NSLog(@"| |＼／| |／_ ＼/  _ ＼  _／_ ＼| | | |");
    NSLog(@"| |   | |  (_) |  __／ || (_) | |_| |");
    NSLog(@"|_|   |_|＼___／＼___|_| ＼___／＼__,_|");
    NSLog(@"Product by ©HT&L 2009-2013, Developer: @bi119aTe5hXk. @Ariagle.");
    NSLog(@"なにこれ(°Д°)？！");
    if (debugmode == YES) {
        NSLog(@"Your system version is:%@",[[UIDevice currentDevice] systemVersion]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Welcome to test MoeApps beta"
                                                            message:@"This is a pre-release version of MoeApps, any problem please contact @bi119aTe5hXk. Thanks."
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                                  otherButtonTitles:nil];
        alertView.tag = 13;
        [alertView show];
    }
    
    userdefault = [NSUserDefaults standardUserDefaults];
    [userdefault registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"Voice",nil]];
    [userdefault registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], @"FirstTimeRun",nil]];
    isVoiceEnable = [userdefault boolForKey:@"Voice"];
    isFirstTimeRun = [userdefault boolForKey:@"FirstTimeRun"];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
    }
    
    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-23799776-2"
                                           dispatchPeriod:10
                                                 delegate:nil];
    NSError *error;
    /*
     if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
     name:@"iOS1"
     value:@"iv1"
     withError:&error]) {
     NSLog(@"%@",error);
     // Handle error here
     }
     */
    NSString *device = @"";
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        device = @"iPad";
    }else{
        device = @"iPhone/iPod";
    }
    if (![[GANTracker sharedTracker] trackEvent:@"OS Type"
                                         action:device
                                          label:@"System Version"
                                          value:[[UIDevice currentDevice] systemVersion]
                                      withError:&error]){
        NSLog(@"%@",error);
    }
    if (![[GANTracker sharedTracker] trackPageview:@"/" withError:&error]) {
        NSLog(@"%@",error);
    }
    moeapi = [[MoeAppsAPI alloc] initWithdelegate:self];
    
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound |
                                                                           UIRemoteNotificationTypeAlert)];
    needshowmsg = NO;
    
    if (isVoiceEnable == YES) {
        if (isFirstTimeRun == NO) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"okaerigoshujin_01" ofType:@"wav"];
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
            self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
            self.audio.volume = 1.0;
            self.audio.delegate = self;
            [self.audio prepareToPlay];
            [self.audio play];
        }else{
            NSString *path = [[NSBundle mainBundle] pathForResource:@"hajimemashide" ofType:@"mp3"];
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
            self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
            self.audio.volume = 1.0;
            self.audio.delegate = self;
            [self.audio prepareToPlay];
            [self.audio play];
        }
        [userdefault setBool:NO forKey:@"FirstTimeRun"];
    }
    
    
    return YES;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
}



- (void)applicationWillResignActive:(UIApplication *)application{
    
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    [userdefault synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application{
    
}
-(void)registerpush{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound |
                                                                           UIRemoteNotificationTypeAlert)];
    needshowmsg = YES;
}

- (void)api:(MoeAppsAPI *)api readyWithList:(NSArray *)list{
    if ([[list valueForKey:@"response"] valueForKey:@"need_upgrade"] == [NSNumber numberWithBool:YES]) {
        updateurl = [[list valueForKey:@"response"] valueForKey:@"upgrade_url"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UPDATE_TITLE",@"")
                                                            message:NSLocalizedString(@"UPDATE_MSG",@"")
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                  otherButtonTitles:NSLocalizedString(@"OK",@""), nil];
        alertView.tag = 10;
        [alertView show];
    }else{
        if (needshowmsg == YES) {
            NSLog(@"Not need update");
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"UP_TO_DATE",@"")
                                                                message:nil
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                                      otherButtonTitles:nil];
            alertView.tag = 11;
            [alertView show];
        }
    }
    
    
}
- (void)api:(MoeAppsAPI *)api requestFailedWithError:(NSError *)error{
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateurl]];
        }
    }
    
}
//Push part
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    if (debugmode == YES) {
        NSLog(@"deviceToken: %@", deviceToken);
    }
    NSString* newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [moeapi appinitwithVersion:build WithPushToken:newToken];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [moeapi appinitwithVersion:build WithPushToken:nil];
    if (debugmode == YES) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR",@"")
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                                  otherButtonTitles:nil];
        alertView.tag = 12;
        [alertView show];
    }
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"Message %@",userInfo);
    if (debugmode == YES) {
        if ([[userInfo objectForKey:@"aps"] objectForKey:
             @"alert"]!=NULL) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Push Received",@"")
                                                            message:[NSString stringWithFormat:@"%@",userInfo]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                                  otherButtonTitles:nil,nil];
            [alert show];
        }
    }
}
@end
