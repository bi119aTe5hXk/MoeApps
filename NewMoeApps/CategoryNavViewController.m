//
//  CategoryNavViewController.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-12-17.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "CategoryNavViewController.h"
@interface CategoryNavViewController ()

@end

@implementation CategoryNavViewController

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Category",@"") image:[UIImage imageNamed:@"UITabBarStar.png"] tag:1];
}


-(void)viewWillAppear:(BOOL)animated{
    
    //self.tabBarItem.image = [UIImage imageNamed:@"UITabBarStar.png"];
    //self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Category",@"") image:[UIImage imageNamed:@"UITabBarStar.png"] tag:1];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
