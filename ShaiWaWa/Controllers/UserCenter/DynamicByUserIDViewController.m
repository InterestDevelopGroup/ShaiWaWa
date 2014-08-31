//
//  DynamicByUserIDViewController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "DynamicByUserIDViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "UIViewController+BarItemAdapt.h"
#import "DynamicCell.h"
#import "DynamicDetailViewController.h"
#import "AppMacros.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"

@interface DynamicByUserIDViewController ()
{
    NSMutableArray *dyArray;
}
@property (nonatomic,assign) int currentOffset;
@end

@implementation DynamicByUserIDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currentOffset = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}


#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"动态";
    [self setLeftCusBarItem:@"square_back" action:nil];
    dyArray = [[NSMutableArray alloc] init];
    [_dyTableView clearSeperateLine];
    [_dyTableView registerNibWithName:@"DynamicCell" reuseIdentifier:@"Cell"];
    [_dyTableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_dyTableView setHeaderRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    [_dyTableView addFooterWithTarget:self action:@selector(loadMoreData)];
    [_dyTableView setFooterPullToRefreshText:NSLocalizedString(@"PullTOLoad", nil)];
    [_dyTableView setFooterRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    
    [_dyTableView headerBeginRefreshing];
}


- (void)refreshData
{
    _currentOffset = 0;
    [self showOnlyMyBabyDyList];
}

- (void)loadMoreData
{
    _currentOffset = [dyArray count];
    [self showOnlyMyBabyDyList];
}



- (void)showOnlyMyBabyDyList
{
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getRecordByUserID:@{@"offset":[NSString stringWithFormat:@"%i",_currentOffset], @"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"uid":users.uid} completionBlock:^(id object) {
        [_dyTableView headerEndRefreshing];
        [_dyTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            dyArray = object;
        }
        else
        {
            [dyArray addObjectsFromArray:object];
        }
        
        [_dyTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoadFinish", nil)];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error)
        {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_dyTableView headerEndRefreshing];
        [_dyTableView footerEndRefreshing];
    }];
    
}


#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    

    return dynamicCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] init];

    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

@end
