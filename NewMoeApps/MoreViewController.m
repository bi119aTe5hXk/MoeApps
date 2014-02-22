//
//  MoreViewController.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-12-25.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = NSLocalizedString(@"MORE", nil);
    
    self.hcaTitle.text = NSLocalizedString(@"HOW_TO_CREAT_ACCOUNT_TITLE", nil);
    [self.hcaTitlePAD setTitle:NSLocalizedString(@"HOW_TO_CREAT_ACCOUNT_TITLE", nil) forState:UIControlStateNormal];
    self.audioswtitle.text = NSLocalizedString(@"ENABLE_AUDIO", nil);
    [self.audiobtn setTitle:NSLocalizedString(@"AUDIO_EXAMPLE_BTN", nil) forState:UIControlStateNormal];
    [self.checkupdatebtn setTitle:NSLocalizedString(@"CHECK_UPDATE_BTN", nil) forState:UIControlStateNormal];
    
    self.userdefault = [NSUserDefaults standardUserDefaults];
    self.isVoiceEnabled = [self.userdefault boolForKey:@"Voice"];
    detailview_PAD = [DetailViewController_iPad alloc];
    
    if (self.isVoiceEnabled == YES) {
        self.isVoiceEnabled = YES;
        [self.audiosw setOn:YES animated:NO];
        [self.userdefault setBool:YES forKey:@"Voice"];
    }else{
        self.isVoiceEnabled = NO;
        [self.audiosw setOn:NO animated:NO];
        [self.userdefault setBool:NO forKey:@"Voice"];
    }
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.versionbuild.text = [NSString stringWithFormat:@"Ver:%@ Build:%@",version,build];
}
-(void)viewWillAppear:(BOOL)animated{
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)pushswchanged:(id)sender{
    
}
-(IBAction)registerpushupdate:(id)sender{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] registerpush];
}
-(IBAction)audioswchanged:(id)sender{
    if (self.isVoiceEnabled == YES) {
        self.isVoiceEnabled = NO;
        detailview_PAD.isVoiceEnabled = NO;
        [self.audiosw setOn:NO animated:YES];
        [self.userdefault setBool:NO forKey:@"Voice"];
    }else{
        self.isVoiceEnabled = YES;
        detailview_PAD.isVoiceEnabled = YES;
        [self.audiosw setOn:YES animated:YES];
        [self.userdefault setBool:YES forKey:@"Voice"];
    }
    [self.userdefault synchronize];
}

-(IBAction)playsoundexamble:(id)sender{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"amitarofactory_02" ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
    _theAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    _theAudio.volume = 1.0;
    _theAudio.delegate = self;
    [_theAudio prepareToPlay];
    [_theAudio play];
}

-(IBAction)PADhowcreate:(id)sender{
    HowCreateViewController *howcreateview = [self.storyboard instantiateViewControllerWithIdentifier:@"HowCreateViewController"];
    [self presentViewController:howcreateview animated:YES completion:^{
        nil;
    }];
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
////#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return NSLocalizedString(@"HOW_TO_TITLE",nil);
    }
    if (section == 1) {
        return NSLocalizedString(@"VOICE_TITLE",nil);
    }
    if (section == 2) {
        return NSLocalizedString(@"SETTINGS_TITLE",nil);
    }
    return @"";
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return @"";
    }
    if (section == 1) {
        return NSLocalizedString(@"VOICE_CREDIT",nil);
    }
    if (section == 2) {
        return NSLocalizedString(@"DEV_CREDIT",nil);
    }
    return @"";
}


@end
