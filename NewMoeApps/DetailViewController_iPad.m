//
//  DetailViewController_iPad.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-12-5.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "DetailViewController_iPad.h"
@interface DetailViewController_iPad ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController_iPad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = @"";//NSLocalizedString(@"App Detail",@"");
    self.inittitle.text = NSLocalizedString(@"PAD_WELCOME_TITLE", @"");
    [self.inittitle setHidden:NO];
    [self.initview setHidden:NO];
    [self configureView];
    [self loadAdmobAdView];
    
    
    self.userdefault = [NSUserDefaults standardUserDefaults];
    self.isVoiceEnabled = [self.userdefault boolForKey:@"Voice"];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.inittitle setHidden:NO];
    [self.initview setHidden:NO];
    self.inittitle.text = NSLocalizedString(@"PAD_WELCOME_TITLE", @"");
    self.apptitle.text = @"";
    self.company.text = @"";
    self.size.text = @"";
    self.category.text = @"";
    [self.storebtn setTitle:@"" forState:UIControlStateNormal];
}
-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [moeapi cancelConnection];
    [checkapp cancelRequest];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)setDetailItem:(id)newDetailItem{
    if (_detailItem != newDetailItem){
        _detailItem = newDetailItem;
        [self configureView];
    }
    if (self.masterPopoverController != nil){
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}
- (void)configureView{
    [self.inittitle setHidden:YES];
    [self.initview setHidden:YES];
    // Update the user interface for the detail item.
    self.apptitle.text = @"";
    self.company.text = @"";
    self.size.text = @"";
    self.category.text = @"";
    self.appicon.image = nil;
    self.description.text = @"";
    [self.storebtn setTitle:@"" forState:UIControlStateNormal];
    for(img in [self.preveiwscroll subviews]) {
        [img removeFromSuperview];
    }
    self.navigationItem.rightBarButtonItem = nil;
    
    if (self.detailItem) {
        moeapi = [[MoeAppsAPI alloc] initWithdelegate:self];
        [moeapi getAppDetailwithAppID:self.detailItem];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //NSLog(@"LoadAppID:%@",self.detailItem);
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)api:(MoeAppsAPI *)api readyWithList:(NSArray *)list{
    [self.inittitle setHidden:YES];
    [self.initview setHidden:YES];
    self.title = NSLocalizedString(@"App Detail",@"");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIBarButtonItem *sharebtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                              target:self
                                                                              action:@selector(shareAction:)];
    UIBarButtonItem *tuibtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply
                                                                            target:self
                                                                            action:@selector(viewinTongbuTui:)];
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tbtui://opendetail"]]) {
        self.navigationItem.rightBarButtonItems = @[sharebtn,tuibtn];
    }else{
        self.navigationItem.rightBarButtonItem = sharebtn;
    }
    
    self.appdetailarray = [[list valueForKey:@"response"] valueForKey:@"app"];
    
    self.apptitle.text = [self.appdetailarray valueForKey:@"title"];
    self.company.text = [self.appdetailarray valueForKey:@"copyright"];
    self.category.text = [self.appdetailarray valueForKey:@"category"];
    self.size.text = [self.appdetailarray valueForKey:@"size"];
    [self.appicon setImageWithURL:[self.appdetailarray valueForKey:@"img_175"] placeholderImage:nil];
    if ([[self.appdetailarray valueForKey:@"price"] isEqual: @"0"] || [[self.appdetailarray valueForKey:@"price"] isEqual: @"無料"]) {
        [self.storebtn setTitle:NSLocalizedString(@"Free",@"") forState:UIControlStateNormal];
    }else{
        [self.storebtn setTitle:[self.appdetailarray valueForKey:@"price"] forState:UIControlStateNormal];
    }
    
    iHasApp *detectionObject = [[iHasApp alloc] init];
    detectionObject.country = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    [detectionObject detectAppDictionariesWithIncremental:^(NSArray *appIds) {
        if (debugmode == YES) {
            //NSLog(@"Incremental appIds.count: %i", appIds.count);
        }
        
        if ([[NSString stringWithFormat:@"%@",appIds] rangeOfString:self.detailItem].location != NSNotFound) {
            //NSLog(@"installed!");
            [self.storebtn setTitle:NSLocalizedString(@"INSTALLED", nil) forState:UIControlStateNormal];
            [self.storebtn setEnabled:NO];
        }else{
            //NSLog(@"not installed!");
            [self.storebtn setEnabled:YES];
        }
    } withSuccess:^(NSArray *appIds) {
        if (debugmode == YES) {
            //NSLog(@"Successful appIds.count: %i", appIds.count);
        }
        
    } withFailure:^(NSError *error) {
        //NSLog(@"Failure: %@", error.localizedDescription);
        [self.storebtn setEnabled:YES];
    }];
    
    checkapp = [[CheckAppInstalled alloc] initWithdelegate:self];
    [checkapp checkappinstalledWithAppID:self.detailItem];
    
    
    
    
    self.description.text = [_appdetailarray valueForKey:@"description"];
    self.description.font = [UIFont systemFontOfSize:12];
    NSString *text = self.description.text;
    
    CGSize stringSize = [text sizeWithFont:[UIFont systemFontOfSize:12]
                         constrainedToSize:CGSizeMake(668, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByWordWrapping];
    [self.description setFrame:CGRectMake(20, 598, 668, stringSize.height+500)];
    
    
    int ippiccount = [[self.appdetailarray valueForKey:@"iphone_screenshots"] count];
    int ipadpiccount = [[self.appdetailarray valueForKey:@"ipad_screenshots"] count];
    
    [self.preveiwscroll setContentSize:CGSizeMake((ippiccount+ipadpiccount)*320, 378)];
    
    if (ippiccount > 0 && ipadpiccount == 0) {
        //iphone
        for (int i=0; i<ippiccount; i++) {
            CGRect iphoneview = CGRectMake(i*320, 0, 320, 378);
            img = [[UIImageView alloc] initWithFrame:iphoneview];
            [img setImageWithURL:[NSURL URLWithString:[[self.appdetailarray valueForKey:@"iphone_screenshots"] objectAtIndex:i]]];
            [img setContentMode:UIViewContentModeScaleAspectFit];
            [self.preveiwscroll addSubview:img];
            img = nil;
        }
    }else if (ipadpiccount > 0 && ippiccount > 0) {
        //universal
        for (int i=0; i<ippiccount; i++) {
            CGRect iphoneview = CGRectMake(i*320, 0, 320, 378);
            img = [[UIImageView alloc] initWithFrame:iphoneview];
            [img setImageWithURL:[NSURL URLWithString:[[self.appdetailarray valueForKey:@"iphone_screenshots"] objectAtIndex:i]]];
            [img setContentMode:UIViewContentModeScaleAspectFit];
            [self.preveiwscroll addSubview:img];
            img = nil;
        }
        for (int i=0; i<ipadpiccount; i++) {
            CGRect uniview = CGRectMake((i+ippiccount)*320, 0, 320, 378);
            
            img = [[UIImageView alloc] initWithFrame:uniview];
            [img setImageWithURL:[NSURL URLWithString:[[self.appdetailarray valueForKey:@"ipad_screenshots"] objectAtIndex:i]]];
            [img setContentMode:UIViewContentModeScaleAspectFit];
            [self.preveiwscroll addSubview:img];
            img = nil;
        }
    }else if (ipadpiccount > 0 && ippiccount == 0) {
        //ipad
        for (int i=0; i<ipadpiccount; i++) {
            CGRect ipadview = CGRectMake(i*320, 0, 320, 378);
            
            img = [[UIImageView alloc] initWithFrame:ipadview];
            [img setImageWithURL:[NSURL URLWithString:[[self.appdetailarray valueForKey:@"ipad_screenshots"] objectAtIndex:i]]];
            [img setContentMode:UIViewContentModeScaleAspectFit];
            [self.preveiwscroll addSubview:img];
            img = nil;
        }
    }
    
    
    [self.scrollview setContentSize:CGSizeMake(703, stringSize.height + 1000)];
    [self.scrollview setScrollEnabled:YES];
    
}
-(void)CheckApp:(CheckAppInstalled *)app isInstalled:(BOOL)installed{
    if (installed == YES) {
        [self.storebtn setTitle:NSLocalizedString(@"INSTALLED", nil) forState:UIControlStateNormal];
        [self.storebtn setEnabled:NO];
        
        
    }else{
        
    }
}
-(void)api:(MoeAppsAPI *)api requestFailedWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR",@"")
                                                        message:[error localizedDescription]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                              otherButtonTitles:NSLocalizedString(@"Retry",@""), nil];
    alertView.tag = 6;
    [alertView show];
}
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 6) {
        if(buttonIndex > 0){
            if(buttonIndex == 1){
                [moeapi getAppDetailwithAppID:self.detailItem];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }else{
                //exit(0);
            }
        }
    }
}
- (IBAction)shareAction:(id)sender{
    if ([self.detailItem length] != 0) {
        NSString *titleToShare = [_appdetailarray valueForKey:@"title"];
        NSString *urlToShare = [_appdetailarray valueForKey:@"url"];
        NSString *hashtag = @"#MoeApps";
        UIImage *imageToShare = self.appicon.image;
        NSArray *itemsToShare = @[titleToShare,urlToShare,imageToShare,hashtag];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeSaveToCameraRoll,
                                             UIActivityTypePrint,
                                             UIActivityTypeAssignToContact]; //needn't
        [self presentViewController:activityVC animated:YES completion:nil];
        //[[[self parentViewController] parentViewController] presentViewController:activityVC animated:YES completion:nil];
        [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
            //Dismiss here
            [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            
        }];
    }
}



-(IBAction)appstorebtnpressd:(id)sender{
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:self.detailItem withError:&error]) {
         NSLog(@"%@",error);
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0) {
        NSDictionary *params = @{ SKStoreProductParameterITunesItemIdentifier: self.detailItem };
        SKStoreProductViewController *store = [[SKStoreProductViewController alloc] init];
        store.delegate = self;
        [store loadProductWithParameters:params completionBlock:^(BOOL result, NSError *error) {
            if (!result) {
                double delayInSeconds = 1.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_appdetailarray valueForKey:@"url"]]];
                    
                });
            }
        }];
        [self presentViewController:store animated:YES completion:nil];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_appdetailarray valueForKey:@"url"]]];
    }
}
-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

-(IBAction)viewinTongbuTui:(id)sender{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tbtui://opendetail"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tbtui://opendetail?id=%@",self.detailItem]]];
    }
}



-(void)loadAdmobAdView{
    [bannerView_ removeFromSuperview];
    bannerView_ = nil;
    bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    bannerView_.adUnitID = @"a152b18c3368568";
    bannerView_.rootViewController = self;
    [self.view addSubview:bannerView_];
    [bannerView_ setDelegate:self];
    GADRequest *request = [GADRequest request];
    request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,nil];
    [bannerView_ loadRequest:request];
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    //NSLog(@"didFailToReceiveAdmobWithError%@", [error localizedDescription]);
    //[self loadiAdView];
    [self loadAdmobAdView];
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    //NSLog(@"Ad loaded");
    //[UIView beginAnimations:@"BannerSlide" context:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        bannerView.frame = CGRectMake(0.0,
                                      self.view.frame.size.height -
                                      bannerView.frame.size.height - 50,
                                      bannerView.frame.size.width,
                                      bannerView.frame.size.height);
    }else{
        bannerView.frame = CGRectMake(0.0,
                                      self.view.frame.size.height -
                                      bannerView.frame.size.height,// + 10,
                                      bannerView.frame.size.width,
                                      bannerView.frame.size.height);
    }
    [UIView commitAnimations];
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self loadAdmobAdView];
}


#pragma mark - Voice
-(IBAction)touchx:(id)sender{
    if (self.isVoiceEnabled == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ecchihentai_01" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
        self.audio.volume = 1.0;
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        [self.audio play];
    }
}

-(IBAction)touchhead:(id)sender{
    if (self.isVoiceEnabled == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"nyaanyaa_01" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
        self.audio.volume = 1.0;
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        [self.audio play];
    }
}
-(IBAction)touchtail1:(id)sender{
    if (self.isVoiceEnabled == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ittaai_01" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
        self.audio.volume = 1.0;
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        [self.audio play];
    }
}
-(IBAction)touchtail2:(id)sender{
    if (self.isVoiceEnabled == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"aaan_01" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
        self.audio.volume = 1.0;
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        [self.audio play];
    }
}
-(IBAction)touchtail3:(id)sender{
    if (self.isVoiceEnabled == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fueen_01" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
        self.audio.volume = 1.0;
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        [self.audio play];
    }
}
-(IBAction)touchLear:(id)sender{
    if (self.isVoiceEnabled == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"ijiwaru_02" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
        self.audio.volume = 1.0;
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        [self.audio play];
    }
}
-(IBAction)touchRear:(id)sender{
    if (self.isVoiceEnabled == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"goshujinsama_03" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
        self.audio.volume = 1.0;
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        [self.audio play];
    }
}
-(IBAction)touchLhend:(id)sender{
    if (self.isVoiceEnabled == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"hainandesyou_01" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
        self.audio.volume = 1.0;
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        [self.audio play];
    }
}
-(IBAction)touchRhend:(id)sender{
    if (self.isVoiceEnabled == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"oi_02" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
        self.audio.volume = 1.0;
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        [self.audio play];
    }
}
-(IBAction)touchLleg:(id)sender{
    if (self.isVoiceEnabled == YES) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"fuunda_02" ofType:@"wav"];
        NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
        self.audio = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
        self.audio.volume = 1.0;
        self.audio.delegate = self;
        [self.audio prepareToPlay];
        [self.audio play];
    }
}
-(IBAction)touchRleg:(id)sender{
    if (self.isVoiceEnabled == YES) {
        
    }
}
-(IBAction)touchmouth:(id)sender{
    if (self.isVoiceEnabled == YES) {
        
    }
}
-(IBAction)touchLface:(id)sender{
    if (self.isVoiceEnabled == YES) {
        
    }
}
-(IBAction)touchRface:(id)sender{
    if (self.isVoiceEnabled == YES) {
        
    }
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController{
    barButtonItem.title = NSLocalizedString(@"App List", @"");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
