//
//  MyGoodFriendsListViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MyGoodFriendsListViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "MyGoodFriendsListCell.h"
#import "FriendHomeViewController.h"
#import "MyGoodFriendsListViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "APPMacros.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "Friend.h"
#import "UIImageView+WebCache.h"
@interface MyGoodFriendsListViewController ()
{
    NSMutableArray *friendList;
    int curretOffset;
    int apiType;    //用于分辨是获取好友列表和搜索好友接口
    NSString * keyword;
}
@end

@implementation MyGoodFriendsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        friendList = [@[] mutableCopy];
        curretOffset = 0;
        apiType = 0;
        keyword = @"";
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
    self.title = @"我的好友";
    [self setLeftCusBarItem:@"square_back" action:nil];
    friendList = [[NSMutableArray alloc] init];
    UIImage *img = [[UIImage imageNamed:@"main_2-bg2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    _goodFriendListTableView.backgroundView = imgView;
    [_goodFriendListTableView registerNibWithName:@"MyGoodFriendsListCell" reuseIdentifier:@"Cell"];
    /*
    if ([friendList count]*80 < _goodFriendListTableView.bounds.size.height) {
        _goodFriendListTableView.frame = CGRectMake(20, 60, 285,[friendList count]*80);
    }
    */
    
    [_goodFriendListTableView clearSeperateLine];

    [_goodFriendListTableView addHeaderWithTarget:self action:@selector(refresh)];
    [_goodFriendListTableView setHeaderRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    [_goodFriendListTableView addFooterWithTarget:self action:@selector(loadMore)];
    [_goodFriendListTableView setFooterPullToRefreshText:NSLocalizedString(@"PullTOLoad", nil)];
    [_goodFriendListTableView setFooterRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    _goodFriendListTableView.delegate = self;
    _goodFriendListTableView.dataSource = self;
    
    [_goodFriendListTableView headerBeginRefreshing];
}


- (void)refresh
{
    curretOffset = 0;
    if(apiType == 0)
    {
        [self getFriends];
    }
    else if(apiType == 1)
    {
        [self searchFriends];
    }
}

- (void)loadMore
{
    curretOffset = [friendList count];
    if(apiType == 0)
    {
        [self getFriends];
    }
    else if(apiType == 1)
    {
        [self searchFriends];
    }

}

- (void)getFriends
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] getFriendList:@{@"uid":user.uid,@"offset":[NSString stringWithFormat:@"%i",curretOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize]} completionBlock:^(id object) {
        
        [_goodFriendListTableView headerEndRefreshing];
        [_goodFriendListTableView footerEndRefreshing];
        if(curretOffset == 0)
        {
            if(object == nil || [object count] == 0)
            {
                [SVProgressHUD showErrorWithStatus:@"暂时没有好友."];
                return ;
            }
            friendList = object;
        }
        else
        {
            
            [friendList addObjectsFromArray:object];
        }
        [SVProgressHUD dismiss];
        [_goodFriendListTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_goodFriendListTableView headerEndRefreshing];
        [_goodFriendListTableView footerEndRefreshing];
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
    [[HttpService sharedInstance] searchFriend:@{@"uid":user.uid,@"offset":[NSString stringWithFormat:@"%i",curretOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"keyword":keyword} completionBlock:^(id object) {
        
        [_goodFriendListTableView headerEndRefreshing];
        [_goodFriendListTableView footerEndRefreshing];
        if(curretOffset == 0)
        {
            if(object == nil || [object count] == 0)
            {
                [SVProgressHUD showErrorWithStatus:@"没有搜索到好友."];
                return ;
            }
            friendList = [NSMutableArray arrayWithArray:object];
        }
        else
        {
            
            [friendList addObjectsFromArray:object];
        }
        [SVProgressHUD dismiss];
        [_goodFriendListTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_goodFriendListTableView headerEndRefreshing];
        [_goodFriendListTableView footerEndRefreshing];
        NSString * msg = responseString;
        if(error)
        {
            msg = @"搜索失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - UITableView DataSources and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    MyGoodFriendsListCell *cell = (MyGoodFriendsListCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    
    Friend *friend = friendList[indexPath.row];
    [cell.headPicView sd_setImageWithURL:[NSURL URLWithString:friend.avatar] placeholderImage:[UIImage imageNamed:@"baby_mama@2x.png"]];
    cell.nickNameLabel.text = friend.username;
    cell.countOfBabyLabel.text = [NSString stringWithFormat:@"%@个宝宝",friend.baby_count];
    //判断好友类型，1为普通朋友，2为配偶
    if ([friend.type intValue] == 1) {
        cell.remarksLabel.text = @"普通朋友";
    }else{
        if ([friend.sex intValue] == 1) {    //1为男，0为女
            cell.remarksLabel.text = @"孩子他爸";
        }else{
            cell.remarksLabel.text = @"孩子他妈";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendHomeViewController *friendHomeVC = [[FriendHomeViewController alloc] init];
    Friend *friend = friendList[indexPath.row];
    friendHomeVC.friendId = friend.friend_id;
    [self.navigationController pushViewController:friendHomeVC animated:YES];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    if([textField.text length] != 0)
    {
        keyword = textField.text;
        apiType = 1;
        
    }
    else
    {
        apiType = 0;
    }
    
    [_goodFriendListTableView headerBeginRefreshing];
    return YES;
}

- (IBAction)searchFriend:(id)sender {
    [self.view endEditing:YES];
    keyword = _keyworkField.text;
    [self searchFriends];
}


@end
