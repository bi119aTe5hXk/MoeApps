//
//  TopViewController.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-7-31.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "NewViewController.h"
#import "DetailViewController_iPad.h"
@interface NewViewController ()

@end

@implementation NewViewController

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
    self.userdefault = [NSUserDefaults standardUserDefaults];
    self.isVoiceEnabled = [self.userdefault boolForKey:@"Voice"];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(addAction:)];
	self.navigationItem.leftBarButtonItem = addButton;
    [self.segswitch removeAllSegments];
    [self.segswitch insertSegmentWithTitle:NSLocalizedString(@"New", @"") atIndex:0 animated:YES];
    [self.segswitch insertSegmentWithTitle:NSLocalizedString(@"Free", @"") atIndex:1 animated:YES];
    [self.segswitch insertSegmentWithTitle:NSLocalizedString(@"Paid", @"") atIndex:2 animated:YES];
    [self.segswitch setSelected:YES];
    [self.segswitch setSelectedSegmentIndex:0];
    self.segswitch.segmentedControlStyle = UISegmentedControlStyleBar;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    applist = [[NSArray alloc] init];
    moeapi = [[MoeAppsAPI alloc] initWithdelegate:self];
    if (page == 0) {
        page = 1;
    }
    
    //[moeapi loadNewestAppListWithType:self.segswitch.selectedSegmentIndex WithPage:page WithCategory:nil];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailviewPAD = (DetailViewController_iPad *)[[self.splitViewController.viewControllers lastObject] topViewController];
    }
    
}
- (void) viewWillAppear:(BOOL)animated{
    [self.view becomeFirstResponder];
    [super viewWillAppear:animated];
    
    if ([applist count] == 0) {
        applist = [[NSArray alloc] init];
        moeapi = [[MoeAppsAPI alloc] initWithdelegate:self];
        [moeapi loadNewestAppListWithType:self.segswitch.selectedSegmentIndex WithPage:page WithCategory:nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        isLoading = YES;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.view resignFirstResponder];
    [super viewWillDisappear:animated];
    [moeapi cancelConnection];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    isLoading = NO;
}

- (IBAction)addAction:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADD_APP_TITLE", @"")
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                          otherButtonTitles:NSLocalizedString(@"ADD_SUBMIT_APP", @""),
                                                            NSLocalizedString(@"ADD_JUMP_SITE", @""),nil];
    alert.tag = 1;
    [alert show];
}
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == 1) {
        if(buttonIndex > 0){
            if(buttonIndex == 1){
                UIAlertView *submitalt = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ADD_SUBMIT_APP_PLACEHOLDER", @"")
                                                                    message:nil
                                                                   delegate:self
                                                          cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                          otherButtonTitles:NSLocalizedString(@"SUBMIT_BTN", @""), nil];
                [submitalt setAlertViewStyle:UIAlertViewStylePlainTextInput];
                submitalt.tag = 3;
                [submitalt show];
                //[[actionSheet textFieldAtIndex:0] setPlaceholder:NSLocalizedString(@"ADD_SUBMIT_APP_PLACEHOLDER", @"")];
                
            }
            if (buttonIndex == 2) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://app.moefou.org/submit"]];
            }
        }
        
    }
    if (actionSheet.tag == 3) {
        if(buttonIndex == 1){
            NSString *input =[[actionSheet textFieldAtIndex:0]text];
            if ([input length] != 0) {
                NSLog(@"%@",input);
                NSString *urlString = @"";
                
                if ([input length] == 9) {
                    urlString = [NSString stringWithFormat:@"http://api.moefou.org/moe-apps/submit.json?app_id=%@",input];
                    
                }else{
                    NSString *urlEncoded = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[[actionSheet textFieldAtIndex:0]text],NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",kCFStringEncodingUTF8));
                    urlString = [NSString stringWithFormat:@"http://api.moefou.org/moe-apps/submit.json?app_url=%@",urlEncoded];
                }
                
                NSURL *url = [[NSURL alloc] initWithString:urlString];
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                NSError *error;
                NSURLResponse *response;
                NSData *urlData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
                NSArray* json = [NSJSONSerialization JSONObjectWithData:urlData
                                                                options:kNilOptions
                                                                  error:&error];
                //NSLog(@"%@",json);
                NSString *msg = @"";
                
                if ([[[json valueForKey:@"response"] valueForKey:@"information"] valueForKey:@"has_error"] == [NSNumber numberWithBool:NO]) {
                    if ([[[json valueForKey:@"response"] valueForKey:@"result"] valueForKey:@"stat"] == [NSNumber numberWithInt:0]) {
                        msg = NSLocalizedString(@"SUBMIT_SUCCESS", @"");
                    }
                    if (self.isVoiceEnabled == YES) {
                        NSString *path = [[NSBundle mainBundle] pathForResource:@"arigatou_04" ofType:@"wav"];
                        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
                        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
                        self.audio.volume = 1.0;
                        self.audio.delegate = self;
                        [self.audio prepareToPlay];
                        [self.audio play];
                    }
                }else{
                    if ([[[json valueForKey:@"response"] valueForKey:@"result"] valueForKey:@"stat"] == [NSNumber numberWithInt:1]) {
                        msg = NSLocalizedString(@"SUBMIT_FAILED_URL_ERROR", @"");
                    }else if ([[[json valueForKey:@"response"] valueForKey:@"result"] valueForKey:@"stat"] == [NSNumber numberWithInt:2]){
                        msg = NSLocalizedString(@"SUBMIT_FAILED_DATABASE_ERROR", @"");
                    }
                    if (self.isVoiceEnabled == YES) {
                        NSString *path = [[NSBundle mainBundle] pathForResource:@"gomennasai_03" ofType:@"wav"];
                        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
                        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
                        self.audio.volume = 1.0;
                        self.audio.delegate = self;
                        [self.audio prepareToPlay];
                        [self.audio play];
                    }
                }
                UIAlertView *submitd = [[UIAlertView alloc] initWithTitle:msg
                                                                  message:nil
                                                                 delegate:nil
                                                        cancelButtonTitle:NSLocalizedString(@"OK",@"")
                                                        otherButtonTitles:nil];
                [submitd show];
            }else{
                
            }
        }
    }
    if (actionSheet.tag == 2) {
        if(buttonIndex > 0){
            if(buttonIndex == 1){
                [moeapi loadNewestAppListWithType:self.segswitch.selectedSegmentIndex WithPage:page WithCategory:nil];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }else{
                //exit(0);
            }
        }
    }
}
-(IBAction)segdidChange:(id)sender{
    page = 1;
    [moeapi cancelConnection];
    applist = [[NSArray alloc] init];
    [self.tableView reloadData];
    [moeapi loadNewestAppListWithType:self.segswitch.selectedSegmentIndex WithPage:page WithCategory:nil];
    if (isLoading == NO) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    isLoading = YES;
}
- (void)onRefresh:(id)sender{
    if (isLoading == NO) {
        [self.refreshControl beginRefreshing];
        page = 1;
        mayhavenext = NO;
        [moeapi cancelConnection];
        applist = [[NSArray alloc] init];
        [self.tableView reloadData];
        [moeapi loadNewestAppListWithType:self.segswitch.selectedSegmentIndex WithPage:page WithCategory:nil];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        isLoading = YES;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)api:(MoeAppsAPI *)api readyWithList:(NSArray *)list{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    isLoading = NO;
    [self.refreshControl endRefreshing];
    if ([[list valueForKey:@"response"] valueForKey:@"apps"] != [NSNull null]) {
        if ([[[list valueForKey:@"response"] valueForKey:@"apps"] count] >= 29) {
            mayhavenext = YES;
        }else{
            mayhavenext = NO;
        }
        applist = [applist arrayByAddingObjectsFromArray:[[list valueForKey:@"response"] valueForKey:@"apps"]];
    }
    [self.tableView reloadData];
}
-(void)api:(MoeAppsAPI *)api requestFailedWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    isLoading = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR",@"")
                                                        message:[error localizedDescription]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                              otherButtonTitles:NSLocalizedString(@"Retry",@""), nil];
    alertView.tag = 2;
    [alertView show];
}




#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        if (mayhavenext == YES) {
            return applist.count + 2;
        }else{
            return applist.count;
        }
    }else{
        if (mayhavenext == YES) {
            return applist.count + 1;
        }else{
            return applist.count;
        }
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AppCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSUInteger row = [indexPath row];
    
    if (row == applist.count+1) {
        cell.apptype.text = @"";
        cell.appname.text = @"";
        cell.price.text = @"";
        cell.appicon.image = nil;
    }else if (row == applist.count && mayhavenext == YES) {
        cell.apptype.text = @"";
        if (applist.count != 0) {
            cell.appname.text = NSLocalizedString(@"Loadmore",@"");
        }else{
            cell.appname.text = @"";
        }
        cell.price.text = @"";
        cell.appcompany.text = @"";
        cell.appicon.image = nil;
    }else{
        NSArray *arr = [applist objectAtIndex:row];
        cell.appname.text = [arr valueForKey:@"title"];
        cell.appname.font= [UIFont boldSystemFontOfSize:14.0];
        cell.appname.numberOfLines = 2;
        cell.apptype.text = [arr valueForKey:@"category"];
        cell.apptype.font = [UIFont systemFontOfSize:12.0];
        [cell.appicon setImageWithURL:[arr valueForKey:@"img_175"] placeholderImage:nil];
        
        if ([[arr valueForKey:@"price"] isEqual: @"0"] || [[arr valueForKey:@"price"] isEqual: @"無料"]) {
            cell.price.text = NSLocalizedString(@"Free",@"");
            cell.price.textColor = [UIColor greenColor];
        }else{
            cell.price.text = [arr valueForKey:@"price"];
            cell.price.textColor = [UIColor redColor];
        }
    }        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == applist.count) {
        if (isLoading == NO) {
            page++;
            [moeapi loadNewestAppListWithType:self.segswitch.selectedSegmentIndex WithPage:page WithCategory:nil];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            isLoading = YES;
        }
    }else if (indexPath.row == applist.count +1){
        
    }else{
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.detailviewPAD.detailItem = [[applist objectAtIndex:indexPath.row] valueForKey:@"app_id"];
        }else{
            self.detailview = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            self.detailview.appid = [[applist objectAtIndex:indexPath.row] valueForKey:@"app_id"];
            [self.navigationController pushViewController:self.detailview animated:YES];
        }
    }
}

@end
