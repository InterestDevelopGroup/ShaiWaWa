//
//  SearchRSViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SearchRSViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "SearchRSCell.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "AppMacros.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"

@interface SearchRSViewController ()
@property (nonatomic,assign) int currentOffset;
@property (nonatomic,assign) int apiType;
@end

@implementation SearchRSViewController
@synthesize searchValue,friendArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _currentOffset = 0;
        _apiType = 1;
        friendArray = [@[] mutableCopy];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"查找好友";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_searchRSListTableView clearSeperateLine];
    [_searchRSListTableView registerNibWithName:@"SearchRSCell" reuseIdentifier:@"Cell"];
    _searchRSField.text = searchValue;
    __weak SearchRSViewController * weakSelf = self;
    [_searchRSListTableView addHeaderWithCallback:^{
        [weakSelf refresh];
    }];
    
    [_searchRSListTableView addFooterWithCallback:^{
        [weakSelf loadMore];
    }];
    
    [_searchRSListTableView headerBeginRefreshing];

}

- (IBAction)cancelAction:(id)sender
{
    _searchRSField.text = @"";
    [_searchRSField resignFirstResponder];
    //[_searchRSListTableView headerBeginRefreshing];
}


- (void)refresh
{
    _currentOffset = 0;
    if(_apiType == 0)
    {
        [self getFriends];
    }
    else if(_apiType == 1)
    {
        [self searchFriends];
    }
}

- (void)loadMore
{
    _currentOffset = [friendArray count];
    if(_apiType == 0)
    {
        [self getFriends];
    }
    else if(_apiType == 1)
    {
        [self searchFriends];
    }
    
}


- (void)getFriends
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] getFriendList:@{@"uid":user.uid,@"offset":[NSString stringWithFormat:@"%i",_currentOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize]} completionBlock:^(id object) {
        
        [_searchRSListTableView headerEndRefreshing];
        [_searchRSListTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            if(object == nil || [object count] == 0)
            {
                [SVProgressHUD showErrorWithStatus:@"暂时没有好友."];
                return ;
            }
            friendArray = object;
        }
        else
        {
            
            [friendArray addObjectsFromArray:object];
        }
        [SVProgressHUD dismiss];
        [_searchRSListTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_searchRSListTableView headerEndRefreshing];
        [_searchRSListTableView footerEndRefreshing];
        NSString * msg = responseString;
        if(error)
        {
            msg = @"加载失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}



- (void)searchFriends
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] searchFriend:@{@"uid":user.uid,@"offset":[NSString stringWithFormat:@"%i",_currentOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"keyword":searchValue} completionBlock:^(id object) {
        
        [_searchRSListTableView headerEndRefreshing];
        [_searchRSListTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            if(object == nil || [object count] == 0)
            {
                [SVProgressHUD showErrorWithStatus:@"没有搜索到好友."];
                return ;
            }
            friendArray = object;
        }
        else
        {
            
            [friendArray addObjectsFromArray:object];
        }
        [SVProgressHUD dismiss];
        [_searchRSListTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_searchRSListTableView headerEndRefreshing];
        [_searchRSListTableView footerEndRefreshing];
        NSString * msg = responseString;
        if(error)
        {
            msg = @"搜索失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


- (void)addLom:(UIButton *)btn
{
    DDLogInfo(@"%i",btn.tag);
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friendArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchRSCell * resultListCell = (SearchRSCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    resultListCell.backgroundColor = [UIColor clearColor];
    resultListCell.addButton.tag = indexPath.row;
    [resultListCell.addButton addTarget:self action:@selector(addLom:) forControlEvents:UIControlEventTouchUpInside];
    return resultListCell;
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if([textField.text length] == 0)
    {
        searchValue = @"";
        _apiType = 0;
        
    }
    else
    {
        searchValue = textField.text;
        _apiType = 1;
    }
    
    [_searchRSListTableView headerBeginRefreshing];
    return YES;
}
@end
