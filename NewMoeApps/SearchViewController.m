//
//  SearchViewController.m
//  NewMoeApps
//
//  Created by bi119aTe5hXk on 13-11-16.
//  Copyright (c) 2013年 HT&L. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

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
    
    self.title = NSLocalizedString(@"Search", @"");
    
    self.seachbar.placeholder = NSLocalizedString(@"Keyword or AppID", @"");
    self.seachbar.scopeButtonTitles = [NSArray arrayWithObjects:NSLocalizedString(@"All", @""),NSLocalizedString(@"Free", @""),NSLocalizedString(@"Paid", @""),nil];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    applist = [[NSArray alloc] init];
    moeapi = [[MoeAppsAPI alloc] initWithdelegate:self];
    if (page == 0) {
        page = 1;
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.detailviewPAD = (DetailViewController_iPad *)[[self.splitViewController.viewControllers lastObject] topViewController];
    }

}
-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [moeapi cancelConnection];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.refreshControl endRefreshing];
    isLoading = NO;
}
- (void)onRefresh:(id)sender{
    if (keyword != nil) {
        if (isLoading == NO) {
            [self.refreshControl beginRefreshing];
            page = 1;
            mayhavenext = NO;
            [moeapi cancelConnection];
            applist = [[NSArray alloc] init];
            [self.tableView reloadData];
            [moeapi SearchWithKeyword:keyword WithPage:page WithType:self.seachbar.selectedScopeButtonIndex];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            isLoading = YES;
        }
    }else{
        [self.refreshControl endRefreshing];
        isLoading = NO;
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
    alertView.tag = 4;
    [alertView show];
}

-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 4) {
        if(buttonIndex > 0){
            if(buttonIndex == 1){
                if (keyword != nil) {
                    [moeapi SearchWithKeyword:keyword WithPage:page WithType:self.seachbar.selectedScopeButtonIndex];
                    isLoading = YES;
                }
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
////#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        if (mayhavenext == YES) {
            return applist.count + 2;
        }else{
            return applist.count + 1;
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
    
    if (row == applist.count+1) {
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == applist.count) {
        page++;
        if (keyword != nil && mayhavenext == YES && isLoading == NO) {
            [moeapi SearchWithKeyword:keyword WithPage:page WithType:self.seachbar.selectedScopeButtonIndex];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            isLoading = YES;
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


#pragma mark Search Bar Delegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
	return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
	if ([searchText length] > 0){
        
	}else{
        applist = nil;
        applist = [[NSArray alloc] init];
        [self.tableView reloadData];
        [searchBar setShowsCancelButton:YES animated:YES];
        isLoading = NO;
        [moeapi cancelConnection];
		//[searchBar resignFirstResponder];
	}
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
	[searchBar resignFirstResponder];
    if ([searchBar.text length] != 0){
        //start search
        keyword = searchBar.text;
        
        applist = nil;
        applist = [[NSArray alloc] init];
        [self.tableView reloadData];
        
        if ([[NSScanner scannerWithString:keyword] scanInt:nil] && [keyword length] == 9) {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                self.detailviewPAD.detailItem = keyword;
            }else{
                self.detailview = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
                self.detailview.appid = keyword;
                [self.navigationController pushViewController:self.detailview animated:YES];
            }
        } else {
            if (isLoading == NO) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [moeapi SearchWithKeyword:searchBar.text WithPage:page WithType:searchBar.selectedScopeButtonIndex];
                isLoading = YES;
            }
        }
    }
}
-(void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    if ([searchBar.text length] != 0 && isLoading == NO) {
        page = 1;
        [moeapi cancelConnection];
        applist = [[NSArray alloc] init];
        [self.tableView reloadData];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [moeapi SearchWithKeyword:searchBar.text WithPage:page WithType:searchBar.selectedScopeButtonIndex];
        isLoading = YES;
    }
}

@end
