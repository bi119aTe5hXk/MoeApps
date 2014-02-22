//
//  HowCreateViewController.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-12-26.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "HowCreateViewController.h"

@interface HowCreateViewController ()

@end

@implementation HowCreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.title = @"How to create a JP-AppStore account.";
    
    [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@HowToCreateURL]]];
    [self.webview setDelegate:self];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(IBAction)PADclose:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
