//
//  SearchViewController.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-11-16.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UITableViewController<UITableViewDataSource,MoeAppsAPIDelegate,UIAlertViewDelegate,UISearchBarDelegate>{
    BOOL isLoading;
    BOOL mayhavenext;
    MoeAppsAPI *moeapi;
    NSInteger page;
    NSArray *applist;
    NSString *keyword;
}
@property (nonatomic, retain) IBOutlet UISearchBar *seachbar;
@property (strong, nonatomic) DetailViewController *detailview;
@property (strong, nonatomic) DetailViewController_iPad *detailviewPAD;
@end
