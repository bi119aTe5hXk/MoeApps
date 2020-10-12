//
//  MoeAppsAPI.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-2-2.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "MoeAppsAPI.h"
#define defaultperpage 30
#define settimeout 50
@interface MoeAppsAPI ()
@property (assign, nonatomic) NSObject <MoeAppsAPIDelegate> *delegate;
@property (retain, nonatomic) NSURLConnection *theConnection;
@property (retain, nonatomic) NSMutableData *receivedData;
- (BOOL)createConnectionWithURL:(NSURL *)url timeoutInterval:(NSTimeInterval)timeout;
@end

@implementation MoeAppsAPI
-(MoeAppsAPI *)initWithdelegate:(NSObject <MoeAppsAPIDelegate> *)delegate{
    self = [super init];
    self.userdefault = [NSUserDefaults standardUserDefaults];
    self.isVoiceEnabled = [self.userdefault boolForKey:@"Voice"];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        devicetype = @"2,3";
	}else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
        devicetype = @"1,2,3";
	}
    
    NSString * language = [NSLocale preferredLanguages][0];
    if (debugmode == YES) {
        NSLog(@"system language: %@",language);
    }
    if ([language rangeOfString:@"Hans"].location != NSNotFound) {
        languagecode = @"chs";
    }else if ([language rangeOfString:@"ja"].location != NSNotFound){
        languagecode = @"jp";
    }else if([language rangeOfString:@"Hant"].location != NSNotFound){
        languagecode = @"cht";
    }else{
        languagecode = @"en";
    }
    
    self.delegate = delegate;
    return self;
}
-(NSString *)mainURLWithPath:(NSString *)path{
    return [NSString stringWithFormat:@"%@%@",@MainURL,path];
}
-(NSString *)backupURLWithPath:(NSString *)path{
    return [NSString stringWithFormat:@"%@%@",@BackUpMainURL,path];
}

-(void)appinitwithVersion:(NSString *)version WithPushToken:(NSString *)token{
    NSString *urlstr = [self mainURLWithPath:[NSString stringWithFormat:@"extra/latest-version.json?version=v%@",version]];
    if (token != nil) {
        urlstr = [urlstr stringByAppendingString:[NSString stringWithFormat:@"&token=%@",token]];
    }
    [self requestJsonWithURL:urlstr];
}

-(void)loadNewestAppListWithType:(NSInteger)type WithPage:(NSInteger)page WithCategory:(NSString *)category{
    NSString *urlstr = [self mainURLWithPath:[NSString stringWithFormat:@"apps.json?device=%@&perpage=%d&page=%ld&lang=%@",devicetype,defaultperpage,(long)page,languagecode]];
    
    if (type == 0) {
        //urlstr = [urlstr stringByAppendingString:@""];
    }
    else if (type == 1){
        urlstr = [urlstr stringByAppendingString:@"&price=free"];
    }
    else if (type == 2){
        urlstr = [urlstr stringByAppendingString:@"&price=paid"];
    }
    
    if (category != nil) {
        NSString *categoryEncoded = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)category,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",kCFStringEncodingUTF8);
        urlstr = [urlstr stringByAppendingString:[NSString stringWithFormat:@"&category=%@",categoryEncoded]];
    }
    
    
    [self requestJsonWithURL:urlstr];
}


-(void)loadCategoryList{
    NSString *urlstr = [self mainURLWithPath:[NSString stringWithFormat:@"categories.json?lang=%@",languagecode]];
    [self requestJsonWithURL:urlstr];
}
-(void)SearchWithKeyword:(NSString *)keyword WithPage:(NSInteger)page WithType:(NSInteger)type{
    NSString *keyEncoded = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)keyword,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",kCFStringEncodingUTF8);
    NSString *urlstr = [self mainURLWithPath:[NSString stringWithFormat:@"apps.json?device=%@&perpage=%d&page=%ld&lang=%@&keyword=%@",devicetype,defaultperpage,(long)page,languagecode,keyEncoded]];
    
    if (type == 0) {
        //urlstr = [urlstr stringByAppendingString:@""];
    }
    else if (type == 1){
        urlstr = [urlstr stringByAppendingString:@"&price=free"];
    }
    else if (type == 2){
        urlstr = [urlstr stringByAppendingString:@"&price=paid"];
    }
    
    [self requestJsonWithURL:urlstr];
}

-(void)getAppDetailwithAppID:(NSString *)app_id{
    NSString *urlstr = [self mainURLWithPath:[NSString stringWithFormat:@"app/detail.json?app_id=%@&lang=%@",app_id,languagecode]];
    [self requestJsonWithURL:urlstr];
}





- (BOOL)requestJsonWithURL:(NSString *)str{
    [self cancelConnection];
    
    str = [str stringByAppendingFormat:@"&api_key=%@",@MFCkey];
    
	NSURL *url = [NSURL URLWithString:str];
    if (debugmode == YES) {
        NSLog(@"Start Load JSON form: %@",url);
    }
	return [self createConnectionWithURL:url
						 timeoutInterval:settimeout];
}

#pragma mark - NSURLConnection
- (BOOL)createConnectionWithURL:(NSURL *)url timeoutInterval:(NSTimeInterval)timeout{
	if(self.theConnection){
		return NO;
	}
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadRevalidatingCacheData
                                                       timeoutInterval:timeout];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	self.theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (self.theConnection) {
		self.receivedData = [NSMutableData data];
	}else {
		return NO;
	}
	return YES;
}
- (void)cancelConnection{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	//if(self.theConnection && self.isBusy){
    [self.theConnection cancel];
    self.theConnection = nil;
    self.receivedData = nil;
	//}
}
- (void)cancelRequest{
	[self.theConnection cancel];
    self.theConnection = nil;
}

# pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [self.receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if (self.receivedData == nil) {
        self.receivedData = [NSMutableData data];
    }
    if (debugmode == YES) {
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"t:%@",str);
    }
    [self.receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	self.theConnection = nil;
    self.receivedData = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if (debugmode == YES) {
        NSLog(@"Connection failed! Error - %@ %@",
              [error localizedDescription],
              [error userInfo][NSURLErrorFailingURLStringErrorKey]);
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR",@"")
                                                        message:NSLocalizedString(@"SERVER_CONNECT_ERROR", @"")
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"OK",@""), nil];
    alertView.tag = 0;
    [alertView show];
    if([self.delegate respondsToSelector:@selector(api:requestFailedWithError:)]){
		[self.delegate api:self requestFailedWithError:error];
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError* error;
    NSArray* json = [NSJSONSerialization JSONObjectWithData:self.receivedData
                                                    options:kNilOptions
                                                      error:&error];
    if(json == nil){
        NSLog(@"Json data is nil");
        if([self.delegate respondsToSelector:@selector(api:requestFailedWithError:)]){
            [self.delegate api:self requestFailedWithError:error];
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
    }else{
        if (debugmode == YES) {
            NSLog(@"json:%@",json);
        }
        
        if ([[[json valueForKey:@"response"] valueForKey:@"information"] valueForKey:@"has_error"] == [NSNumber numberWithBool:NO]) {
            if (debugmode == YES) {
                NSLog(@"information ok %@",[[json valueForKey:@"response"]  valueForKey:@"information"]);
            }
            
            if([self.delegate respondsToSelector:@selector(api:readyWithList:)]){
                [self.delegate api:self readyWithList:json];
            }
        }else{
            NSLog(@"return error %@",[[json valueForKey:@"response"]  valueForKey:@"information"]);
            if([self.delegate respondsToSelector:@selector(api:requestFailedWithError:)]){
                [self.delegate api:self requestFailedWithError:error];
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
    }
    
    self.theConnection = nil;
    self.receivedData = nil;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}



@end
