//
//  DetailViewController.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-8-3.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.apptitle.text = @"";
    self.company.text = @"";
    self.size.text = @"";
    self.category.text = @"";
    [self.storebtn setTitle:@"" forState:UIControlStateNormal];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"App Detail",@"");
    
    moeapi = [[MoeAppsAPI alloc] initWithdelegate:self];
    [moeapi getAppDetailwithAppID:self.appid];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [moeapi cancelConnection];
    [checkapp cancelRequest];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)api:(MoeAppsAPI *)api readyWithList:(NSArray *)list{
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
        if ([[NSString stringWithFormat:@"%@",appIds] rangeOfString:self.appid].location != NSNotFound) {
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
    [checkapp checkappinstalledWithAppID:self.appid];
    
    self.descriptionfield.text = [_appdetailarray valueForKey:@"description"];
    self.descriptionfield.font = [UIFont systemFontOfSize:12];
    NSString *text = self.descriptionfield.text;
    
    CGSize stringSize = [text sizeWithFont:[UIFont systemFontOfSize:12]
                         constrainedToSize:CGSizeMake(280, CGFLOAT_MAX)
                             lineBreakMode:NSLineBreakByWordWrapping];
    [self.descriptionfield setFrame:CGRectMake(20, 508, 280, stringSize.height+500)];
    
    int piccount = [[self.appdetailarray valueForKey:@"iphone_screenshots"] count];
    
    if (piccount > 0) {
        [self.preveiwscroll setContentSize:CGSizeMake(piccount*320, 351)];
        
        for (int i=0; i<piccount; i++) {
            CGRect iphoneview = CGRectMake(i*320, 0, 320, 351);
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:iphoneview];
            [img setImageWithURL:[NSURL URLWithString:[[self.appdetailarray valueForKey:@"iphone_screenshots"] objectAtIndex:i]]];
            [img setContentMode:UIViewContentModeScaleAspectFit];
            [self.preveiwscroll addSubview:img];
        }
    }
    
    [self.scrollview setContentSize:CGSizeMake(320, stringSize.height + 800)];
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
                [moeapi getAppDetailwithAppID:self.appid];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }else{
                //exit(0);
                
            }
        }
    }
}
- (IBAction)shareAction:(id)sender{
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
    
    
}
-(IBAction)appstorebtnpressd:(id)sender{
//    NSError *error;
//    if (![[GANTracker sharedTracker] trackPageview:self.appid withError:&error]) {
//        NSLog(@"%@",error);
//    }
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0) {
//        NSDictionary *params = @{ SKStoreProductParameterITunesItemIdentifier: self.appid };
//        SKStoreProductViewController *store = [[SKStoreProductViewController alloc] init];
//        store.delegate = self;
//        [store loadProductWithParameters:params completionBlock:^(BOOL result, NSError *error) {
//            if (!result) {
//                double delayInSeconds = 1.0;
//                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_appdetailarray valueForKey:@"url"]]];
//                });
//            }
//        }];
//        [self presentViewController:store animated:YES completion:nil];
//    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[_appdetailarray valueForKey:@"url"]]];
//    }
    
    
}
//-(void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController{
//    [self dismissViewControllerAnimated:YES completion:^{
//        nil;
//    }];
//}
-(IBAction)viewinTongbuTui:(id)sender{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tbtui://opendetail"]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tbtui://opendetail?id=%@",self.appid]]];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"INSTALL_TUI_TITLE",@"")
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}

@end
