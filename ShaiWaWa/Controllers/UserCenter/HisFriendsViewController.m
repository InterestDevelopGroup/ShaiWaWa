//
//  HisFriendsViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-9-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "HisFriendsViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "Friend.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "APPMacros.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "MyGoodFriendsListCell.h"
#import "FriendHomeViewController.h"
#import "PersonCenterViewController.h"
#import "UserDefault.h"
#import "UserInfo.h"
@interface HisFriendsViewController ()
@property (nonatomic,strong) NSMutableArray * friendList;
@property (nonatomic,assign) int curretOffset;
@end

@implementation HisFriendsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _friendList = [@[] mutableCopy];
        _curretOffset = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_friendsTableView clearSeperateLine];
    [_friendsTableView addHeaderWithTarget:self action:@selector(refresh)];
    [_friendsTableView addFooterWithTarget:self action:@selector(loadMore)];
    [_friendsTableView headerBeginRefreshing];
    [_friendsTableView registerNibWithName:@"MyGoodFriendsListCell" reuseIdentifier:@"Cell"];
    if(_user)
    {
        self.title = [NSString stringWithFormat:@"%@的好友",_user.username];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)refresh
{
    _curretOffset = 0;
    [self getFriends];
}

- (void)loadMore
{
    _curretOffset = [_friendList count];
    [self getFriends];
    
}

- (void)getFriends
{
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] getFriendList:@{@"uid":_user.uid,@"offset":[NSString stringWithFormat:@"%i",_curretOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize]} completionBlock:^(id object) {
        
        [_friendsTableView headerEndRefreshing];
        [_friendsTableView footerEndRefreshing];
        if(_curretOffset == 0)
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
        [_friendsTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_friendsTableView headerEndRefreshing];
        [_friendsTableView footerEndRefreshing];
        NSString * msg = responseString;
        if(error)
        {
            msg = @"加载失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


#pragma mark - UITableView DataSources and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    MyGoodFriendsListCell *cell = (MyGoodFriendsListCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    Friend *friend = _friendList[indexPath.row];
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
    Friend *friend = _friendList[indexPath.row];
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    if(![friend.friend_id isEqualToString:user.uid])
    {
        FriendHomeViewController *friendHomeVC = [[FriendHomeViewController alloc] initWithNibName:nil bundle:nil];
        friendHomeVC.friendId = friend.friend_id;
        [self.navigationController pushViewController:friendHomeVC animated:YES];
    }
    else
    {
        PersonCenterViewController * vc = [[PersonCenterViewController alloc] initWithNibName:nil bundle:nil];
        [self push:vc];
        vc = nil;
    }
}

@end
