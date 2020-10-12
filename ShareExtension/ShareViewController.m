//
//  ShareViewController.m
//  ShareExtension
//
//  Created by bi119aTe5hXk on 2014/10/28.
//  Copyright (c) 2014年 HT&L. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface ShareViewController ()

@end

@implementation ShareViewController
-(void)viewDidLoad{
    
    NSExtensionItem * urlItem = [self.extensionContext.inputItems firstObject];
    NSItemProvider * urlItemProvider = [[urlItem attachments] lastObject];
    
    if([urlItemProvider hasItemConformingToTypeIdentifier:@"public.url"]){
        [urlItemProvider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(NSURL* Urlstrr, NSError *error) {
            urlstr = Urlstrr.absoluteString;
            
        }];
    }
}

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    NSExtensionItem * urlItem = [self.extensionContext.inputItems firstObject];
    if(!urlItem)
    {
        return NO;
    }
    NSItemProvider * urlItemProvider = [[urlItem attachments] firstObject];
    if(!urlItemProvider)
    {
        return NO;
    }
    if([urlItemProvider hasItemConformingToTypeIdentifier:@"public.url"]&&self.contentText)
    {
        return YES;
    }
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"URL"
                                                                   message:[[NSString alloc] initWithFormat:@"%@",urlstr]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          
                                                              // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
                                                              [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
                                                              
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    
}



- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    
    
    
    return @[];
}

@end
