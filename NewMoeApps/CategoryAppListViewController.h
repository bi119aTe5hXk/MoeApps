//
//  CategoryAppListViewController.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-11-16.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryAppListViewController : UITableViewController<UITableViewDataSource,UIAlertViewDelegate,MoeAppsAPIDelegate>{
    BOOL isLoading;
    BOOL mayhavenext;
    MoeAppsAPI *moeapi;
    NSInteger page;
    NSArray *applist;
}
@property (nonatomic, retain) NSString *categoryname;
@property (strong, nonatomic) DetailViewController *detailview;
@property (strong, nonatomic) DetailViewController_iPad *detailviewPAD;
@end
