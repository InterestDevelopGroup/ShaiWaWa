//
//  ChooseFriendViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChooseFriendViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "FriendSelectedCell.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "AppMacros.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"

@interface ChooseFriendViewController ()
@property(nonatomic,strong) NSMutableArray * friendList;
@property(nonatomic,assign) int currentOffset;
@property(nonatomic,strong) NSString * keyword;
@property(nonatomic,assign) int apiType;
@end

@implementation ChooseFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _friendList = [@[] mutableCopy];
        _currentOffset = 0;
        _apiType = 0;
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
    self.title = @"@谁";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFriendButton setTitle:@"完成" forState:UIControlStateNormal];
    addFriendButton.frame = CGRectMake(0, 0, 40, 30);
    [addFriendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIBarButtonItem *right_addFriend = [[UIBarButtonItem alloc] initWithCustomView:addFriendButton];
    self.navigationItem.rightBarButtonItem = right_addFriend;
    
    [_friendSelectListTableView clearSeperateLine];
    [_friendSelectListTableView registerNibWithName:@"FriendSelectedCell" reuseIdentifier:@"Cell"];
    [_friendSelectListTableView addHeaderWithTarget:self action:@selector(refresh)];
    [_friendSelectListTableView setHeaderRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    [_friendSelectListTableView addFooterWithTarget:self action:@selector(loadMore)];
    [_friendSelectListTableView setFooterPullToRefreshText:NSLocalizedString(@"PullTOLoad", nil)];
    [_friendSelectListTableView setFooterRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    
    [_friendSelectListTableView headerBeginRefreshing];
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
    _currentOffset = [_friendList count];
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
        
        [_friendSelectListTableView headerEndRefreshing];
        [_friendSelectListTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            if(object == nil || [object count] == 0)
            {
                [SVProgressHUD showErrorWithStatus:@"暂时没有好友."];
                return ;
            }
            _friendList = object;
        }
        else
        {
            
            [_friendList addObjectsFromArray:object];
        }
        [SVProgressHUD dismiss];
        [_friendSelectListTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_friendSelectListTableView headerEndRefreshing];
        [_friendSelectListTableView footerEndRefreshing];
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
    [[HttpService sharedInstance] searchFriend:@{@"uid":user.uid,@"offset":[NSString stringWithFormat:@"%i",_currentOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"keyword":_keyword} completionBlock:^(id object) {
        
        [_friendSelectListTableView headerEndRefreshing];
        [_friendSelectListTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            if(object == nil || [object count] == 0)
            {
                [SVProgressHUD showErrorWithStatus:@"没有搜索到好友."];
                return ;
            }
            _friendList = object;
        }
        else
        {
            
            [_friendList addObjectsFromArray:object];
        }
        [SVProgressHUD dismiss];
        [_friendSelectListTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_friendSelectListTableView headerEndRefreshing];
        [_friendSelectListTableView footerEndRefreshing];

        NSString * msg = responseString;
        if(error)
        {
            msg = @"搜索失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendSelectedCell * friendSelectedListCell = (FriendSelectedCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //babyListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    babyListCell.babyImage.image = [UIImage imageNamed:@""];
    //    babyListCell.babyNameLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babyOldLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babySexImage.image = [UIImage imageNamed:@""];
    friendSelectedListCell.backgroundColor = [UIColor clearColor];
    return friendSelectedListCell;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if([textField.text length] != 0)
    {
        _keyword = textField.text;
        _apiType = 1;

        
    }
    else
    {
        _apiType = 0;
    }
    
    [_friendSelectListTableView headerBeginRefreshing];
    return YES;
}
@end
