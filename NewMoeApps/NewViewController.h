//
//  TopViewController.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-7-31.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>

@interface NewViewController : UITableViewController<UITableViewDataSource,UIAlertViewDelegate,AVAudioPlayerDelegate,MoeAppsAPIDelegate>{
    BOOL mayhavenext;
    BOOL isLoading;
    MoeAppsAPI *moeapi;
    NSInteger page;
    NSArray *applist;
    
}
@property (nonatomic, strong) AVAudioPlayer *audio;
@property(nonatomic, retain) NSUserDefaults *userdefault;
@property(nonatomic) BOOL isVoiceEnabled;
@property (nonatomic ,retain) IBOutlet UISegmentedControl *segswitch;

-(IBAction)segdidChange:(id)sender;
@property (strong, nonatomic) DetailViewController *detailview;
@property (strong, nonatomic) DetailViewController_iPad *detailviewPAD;

@end
