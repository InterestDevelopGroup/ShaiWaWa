//
//  ChooseFriendViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-8.
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
#import "Friend.h"
#import "UIImageView+WebCache.h"
#import "SSCheckBoxView.h"
@interface ChooseFriendViewController ()
@property(nonatomic,strong) NSMutableArray * friendList;
@property(nonatomic,strong) NSMutableArray * selectedFriends;
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
        _selectedFriends = [@[] mutableCopy];
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
    [addFriendButton addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)checkboxStateChanged:(SSCheckBoxView *)checkbox
{
    FriendSelectedCell * cell;
    if([checkbox.superview.superview.superview isKindOfClass:[FriendSelectedCell class]])
    {
        cell = (FriendSelectedCell *)checkbox.superview.superview.superview;
    }
    else if([checkbox.superview.superview isKindOfClass:[FriendSelectedCell class]])
    {
        cell = (FriendSelectedCell *)checkbox.superview.superview;
    }
    else
    {
        cell = (FriendSelectedCell *)checkbox.superview;
    }
    
    NSIndexPath * indexPath = [_friendSelectListTableView indexPathForCell:cell];
    Friend * friend = _friendList[indexPath.row];
    if([_selectedFriends containsObject:friend])
    {
        [_selectedFriends removeObject:friend];
    }
    else
    {
        [_selectedFriends addObject:friend];
    }
    [_friendSelectListTableView reloadData];
}

- (void)finishAction:(id)sender
{
    if(self.finishSelectedBlock)
    {
        self.finishSelectedBlock(_selectedFriends);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendSelectedCell * cell = (FriendSelectedCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    Friend * friend = _friendList[indexPath.row];
    [cell.headImgView sd_setImageWithURL:[NSURL URLWithString:friend.avatar] placeholderImage:[UIImage imageNamed:@"user_touxiang"]];
    cell.nickNameLabel.text = friend.username;
    
    [[cell.contentView viewWithTag:10000] removeFromSuperview];
    SSCheckBoxView * checkButton = [[SSCheckBoxView alloc] initWithFrame:cell.isSelectedButton.frame style:kSSCheckBoxViewStyleGlossy checked:[_selectedFriends containsObject:friend]];
    [cell.contentView addSubview:checkButton];
    [checkButton setStateChangedTarget:self selector:@selector(checkboxStateChanged:)];
    checkButton.tag = 10000;
    [cell.isSelectedButton removeFromSuperview];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Friend * friend = _friendList[indexPath.row];
    if([_selectedFriends containsObject:friend])
    {
        [_selectedFriends removeObject:friend];
    }
    else
    {
        [_selectedFriends addObject:friend];
    }
    [_friendSelectListTableView reloadData];
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
