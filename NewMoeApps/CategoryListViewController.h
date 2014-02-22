//
//  CategoryListViewController.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-11-16.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CategoryAppListViewController.h"
@interface CategoryListViewController : UITableViewController<UITableViewDataSource,UIAlertViewDelegate,MoeAppsAPIDelegate>{
    BOOL isLoading;
    MoeAppsAPI *moeapi;
    NSArray *categorylist;
    //CategoryAppListViewController *categoryapplist;
    
}

@end
