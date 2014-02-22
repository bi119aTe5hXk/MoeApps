//
//  MoreViewController.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-12-25.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HowCreateViewController.h"
#import "DetailViewController_iPad.h"
@interface MoreViewController : UITableViewController<AVAudioPlayerDelegate>{
    DetailViewController_iPad *detailview_PAD;
}
@property(nonatomic) NSUserDefaults *userdefault;
@property(nonatomic) BOOL isVoiceEnabled;



@property(nonatomic, retain) IBOutlet UILabel *hcaTitle;
@property(nonatomic, retain) IBOutlet UIButton *hcaTitlePAD;
-(IBAction)PADhowcreate:(id)sender;



@property(nonatomic, retain) IBOutlet UILabel *audioswtitle;
@property (nonatomic, retain) IBOutlet UISwitch *audiosw;
@property(nonatomic, retain) IBOutlet UIButton *audiobtn;
-(IBAction)audioswchanged:(id)sender;
@property (nonatomic, strong) AVAudioPlayer *theAudio;
-(IBAction)playsoundexamble:(id)sender;

@property (nonatomic ,retain) IBOutlet UILabel *versionbuild;
@property(nonatomic, retain) IBOutlet UIButton *checkupdatebtn;
-(IBAction)registerpushupdate:(id)sender;

@end
