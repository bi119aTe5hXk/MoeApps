//
//  HowCreateViewController.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-12-26.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowCreateViewController : UIViewController<UIWebViewDelegate>{
    
}

@property (nonatomic, retain) IBOutlet UIWebView *webview;
-(IBAction)PADclose:(id)sender;
@end
