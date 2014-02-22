//
//  CategoryListViewController.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-11-16.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "CategoryListViewController.h"

@interface CategoryListViewController ()

@end

@implementation CategoryListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    self.tabBarItem.title = NSLocalizedString(@"Category",@"");
    self.title = NSLocalizedString(@"Category",@"");
    
    categorylist = [[NSArray alloc] init];
    moeapi = [[MoeAppsAPI alloc] initWithdelegate:self];
    //[moeapi loadCategoryList];
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    if ([categorylist count] == 0) {
        categorylist = [[NSArray alloc] init];
        moeapi = [[MoeAppsAPI alloc] initWithdelegate:self];
        [moeapi loadCategoryList];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        isLoading = YES;
    }
}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    [moeapi cancelConnection];
    isLoading = NO;
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)onRefresh:(id)sender{
    if (isLoading == NO) {
        [self.refreshControl beginRefreshing];
        [moeapi loadCategoryList];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        isLoading = YES;
    }
}
-(void)api:(MoeAppsAPI *)api readyWithList:(NSArray *)list{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    isLoading = NO;
    
    categorylist = [[list valueForKey:@"response"] valueForKey:@"categories"];
    [self.tableView reloadData];
}
-(void)api:(MoeAppsAPI *)api requestFailedWithError:(NSError *)error{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    isLoading = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"ERROR",@"")
                                                        message:[error localizedDescription]
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                              otherButtonTitles:NSLocalizedString(@"Retry",@""), nil];
    alertView.tag = 5;
    [alertView show];
}
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 5) {
        if(buttonIndex > 0){
            if(buttonIndex == 1){
                [moeapi loadCategoryList];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }else{
                //exit(0);
            }
        }
    }
}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        return categorylist.count+1;
    }else{
        return categorylist.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    NSUInteger row = [indexPath row];
    
    if (row == categorylist.count) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
        cell.imageView.image = nil;
    }else{
        NSArray *arr = [categorylist objectAtIndex:row];
        [cell.imageView setImageWithURL:[arr valueForKey:@"img_175"] placeholderImage:[UIImage imageNamed:@"icon.png"]];
        cell.textLabel.text = [arr valueForKey:@"title"];
        cell.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"CATEGORY_NUM_APP",@""),[arr valueForKey:@"count"]];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [cell.detailTextLabel setAlpha:0.5];
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSIndexPath *indexPath = [self.tableView indexPathsForSelectedRows][0];
    CategoryAppListViewController *categoryapplist = segue.destinationViewController;
    NSUInteger row = [indexPath row];
    if (row == categorylist.count) {
        
    }else{
        categoryapplist.categoryname = [categorylist[indexPath.row] valueForKey:@"name"];
        categoryapplist.title = [categorylist[indexPath.row] valueForKey:@"title"];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryAppListViewController *categoryapplist = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryAppListViewController"];
    NSUInteger row = [indexPath row];
    if (row == categorylist.count) {
        
    }else{
        categoryapplist.categoryname = [categorylist[indexPath.row] valueForKey:@"name"];
        categoryapplist.title = [categorylist[indexPath.row] valueForKey:@"title"];
        [self.navigationController pushViewController:categoryapplist animated:YES];
    }
}

@end
