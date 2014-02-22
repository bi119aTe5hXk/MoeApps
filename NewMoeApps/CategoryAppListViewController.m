//
//  CategoryAppListViewController.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-11-16.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "CategoryAppListViewController.h"

@interface CategoryAppListViewController ()

@end

@implementation CategoryAppListViewController

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
    mayhavenext = NO;
    
    applist = [[NSArray alloc] init];
    moeapi = [[MoeAppsAPI alloc] initWithdelegate:self];
    if (page == 0) {
        page = 1;
    }
    [moeapi loadNewestAppListWithType:nil WithPage:page WithCategory:self.categoryname];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    isLoading = YES;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailviewPAD = (DetailViewController_iPad *)[[self.splitViewController.viewControllers lastObject] topViewController];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.view resignFirstResponder];
    [super viewWillDisappear:animated];
    [moeapi cancelConnection];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    isLoading = NO;
}
- (void)onRefresh:(id)sender{
    if (isLoading == NO) {
        [self.refreshControl beginRefreshing];
        page = 1;
        mayhavenext = NO;
        [moeapi cancelConnection];
        applist = [[NSArray alloc] init];
        [self.tableView reloadData];
        [moeapi loadNewestAppListWithType:nil WithPage:page WithCategory:self.categoryname];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        isLoading = YES;
    }
}
- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)api:(MoeAppsAPI *)api readyWithList:(NSArray *)list{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    isLoading = NO;
    if ([[list valueForKey:@"response"] valueForKey:@"apps"] != [NSNull null]) {
        if ([[[list valueForKey:@"response"] valueForKey:@"apps"] count] >= 29) {
            mayhavenext = YES;
        }else{
            mayhavenext = NO;
        }
        applist = [applist arrayByAddingObjectsFromArray:[[list valueForKey:@"response"] valueForKey:@"apps"]];
    }
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
    alertView.tag = 9;
    [alertView show];
}
-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 9) {
        if(buttonIndex > 0){
            if(buttonIndex == 1){
                [moeapi loadNewestAppListWithType:nil WithPage:page WithCategory:self.categoryname];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                isLoading = YES;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        if (mayhavenext == YES) {
            return applist.count + 2;
        }else{
            return applist.count +1;
        }
    }else{
        if (mayhavenext == YES) {
            return applist.count + 1;
        }else{
            return applist.count;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AppCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    NSUInteger row = [indexPath row];
    
    
    if (row == applist.count + 1) {
        cell.apptype.text = @"";
        cell.appname.text = @"";
        cell.price.text = @"";
        cell.appicon.image = nil;
    }else if (row == applist.count) {
        cell.apptype.text = @"";
        if (mayhavenext == YES) {
            cell.appname.text = NSLocalizedString(@"Loadmore",@"");
        }else{
            cell.appname.text = @"";
        }
        cell.price.text = @"";
        cell.appcompany.text = @"";
        cell.appicon.image = nil;
    }else{
        NSArray *arr = [applist objectAtIndex:row];
        cell.appname.text = [arr valueForKey:@"title"];
        cell.appname.font= [UIFont boldSystemFontOfSize:14.0];
        cell.appname.numberOfLines = 2;
        cell.apptype.text = [arr valueForKey:@"category"];
        cell.apptype.font = [UIFont systemFontOfSize:12.0];
        [cell.appicon setImageWithURL:[arr valueForKey:@"img_175"] placeholderImage:nil];
        
        if ([[arr valueForKey:@"price"] isEqual: @"0"] || [[arr valueForKey:@"price"] isEqual: @"無料"]) {
            cell.price.text = NSLocalizedString(@"Free",@"");
            cell.price.textColor = [UIColor greenColor];
        }else{
            cell.price.text = [arr valueForKey:@"price"];
            cell.price.textColor = [UIColor redColor];
        }
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 69;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if (indexPath.row == applist.count) {
        if (mayhavenext == YES) {
            if (isLoading == NO) {
                page++;
                [moeapi loadNewestAppListWithType:nil WithPage:page WithCategory:self.categoryname];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            }
        }
    }else if (indexPath.row == applist.count +1){
        
    }else{
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            self.detailviewPAD.detailItem = [[applist objectAtIndex:indexPath.row] valueForKey:@"app_id"];
            
        }else{
            self.detailview = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            self.detailview.appid = [[applist objectAtIndex:indexPath.row] valueForKey:@"app_id"];
            [self.navigationController pushViewController:self.detailview animated:YES];
        }
        
    }
}
@end
