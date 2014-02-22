//
//  CheckAppInstalled.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 14-1-24.
//  Copyright (c) 2014年 HT&L. All rights reserved.
//

#import "CheckAppInstalled.h"
@interface CheckAppInstalled ()
@property (assign, nonatomic) NSObject <CheckAppInstalledDelegate> *delegate;
@property (retain, nonatomic) NSURLConnection *connection;
@end
@implementation CheckAppInstalled
-(CheckAppInstalled *)initWithdelegate:(NSObject <CheckAppInstalledDelegate> *)delegate{
    self = [super init];
    self.delegate = delegate;
    return self;
}

-(void)checkappinstalledWithAppID:(NSString *)appid{
    NSString *path = [NSString stringWithFormat:@iTunesSearshBaseURL,appid,[[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode],[[NSLocale currentLocale] objectForKey:NSLocaleCountryCode]];
    NSURL *url = [NSURL URLWithString:path];
    NSURLRequest *urlrequest = [NSURLRequest requestWithURL:url];
    self.connection = [[NSURLConnection alloc] initWithRequest:urlrequest delegate:self];
    [self.connection start];
    
}
-(void)checkappinstalledWithBundleID:(NSString *)bundleid{
    if (APCheckIfAppInstalled(bundleid)){
        NSLog(@"App installed: %@", bundleid);
        if([self.delegate respondsToSelector:@selector(CheckApp:isInstalled:)]){
            [self.delegate CheckApp:self isInstalled:YES];
        }
    }else{
        NSLog(@"App not installed: %@", bundleid);
        if([self.delegate respondsToSelector:@selector(CheckApp:isInstalled:)]){
            [self.delegate CheckApp:self isInstalled:NO];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSLog(@"%@",response);
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"%@,%@",error.localizedDescription,connection);
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"t:%@",str);
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:NULL];
    
    if ([[json objectForKey:@"resultCount"] integerValue] >= 1) {
        NSString *identifier = [[[json objectForKey:@"results"] objectAtIndex:0] valueForKey:@"bundleId"];
        if (APCheckIfAppInstalled(identifier)){
            NSLog(@"App installed: %@", identifier);
            if([self.delegate respondsToSelector:@selector(CheckApp:isInstalled:)]){
                [self.delegate CheckApp:self isInstalled:YES];
            }
            
        }else{
            NSLog(@"App not installed: %@", identifier);
            if([self.delegate respondsToSelector:@selector(CheckApp:isInstalled:)]){
                [self.delegate CheckApp:self isInstalled:NO];
            }
        }
    }
}
-(void)cancelRequest{
    [self.connection cancel];
    self.connection = nil;
}
// Declaration
BOOL APCheckIfAppInstalled(NSString *bundleIdentifier); // Bundle identifier (eg. com.apple.mobilesafari) used to track apps

// Implementation

BOOL APCheckIfAppInstalled(NSString *bundleIdentifier){
	static NSString *const cacheFileName = @"com.apple.mobile.installation.plist";
	NSString *relativeCachePath = [[@"Library" stringByAppendingPathComponent: @"Caches"] stringByAppendingPathComponent: cacheFileName];
	NSDictionary *cacheDict = nil;
	NSString *path = nil;
	// Loop through all possible paths the cache could be in
	for (short i = 0; 1; i++)
	{
        
		switch (i) {
            case 0: // Jailbroken apps will find the cache here; their home directory is /var/mobile
                path = [NSHomeDirectory() stringByAppendingPathComponent: relativeCachePath];
                break;
            case 1: // App Store apps and Simulator will find the cache here; home (/var/mobile/) is 2 directories above sandbox folder
                path = [[NSHomeDirectory() stringByAppendingPathComponent: @"../.."] stringByAppendingPathComponent: relativeCachePath];
                break;
            case 2: // If the app is anywhere else, default to hardcoded /var/mobile/
                path = [@"/var/mobile" stringByAppendingPathComponent: relativeCachePath];
                break;
            default: // Cache not found (loop not broken)
                return NO;
            break; }
		
		BOOL isDir = NO;
		if ([[NSFileManager defaultManager] fileExistsAtPath: path isDirectory: &isDir] && !isDir) // Ensure that file exists
			cacheDict = [NSDictionary dictionaryWithContentsOfFile: path];
		
		if (cacheDict) // If cache is loaded, then break the loop. If the loop is not "broken," it will return NO later (default: case)
			break;
	}
	
	NSDictionary *system = [cacheDict objectForKey: @"System"]; // First check all system (jailbroken) apps
	if ([system objectForKey: bundleIdentifier]) return YES;
	NSDictionary *user = [cacheDict objectForKey: @"User"]; // Then all the user (App Store /var/mobile/Applications) apps
	if ([user objectForKey: bundleIdentifier]) return YES;
	
	// If nothing returned YES already, we'll return NO now
	return NO;
}
@end
