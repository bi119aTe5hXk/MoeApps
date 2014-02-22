//
//  AppCell.h
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-7-31.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppCell : UITableViewCell

@property (nonatomic ,retain) IBOutlet UILabel *appname;
@property (nonatomic ,retain) IBOutlet UILabel *appcompany;
@property (nonatomic ,retain) IBOutlet UIImageView *appicon;
@property (nonatomic ,retain) IBOutlet UILabel *apptype;
@property (nonatomic ,retain) IBOutlet UILabel *price;

@end
