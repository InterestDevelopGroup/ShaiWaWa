//
//  PraiseViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PraiseViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "MyGoodFriendsListCell.h"
#import "OtherInformationViewController.h"
#import "FriendHomeViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "BabyRecord.h"
#import "AppMacros.h"
#import "UIImageView+WebCache.h"
#import "LikeUser.h"
#import "PersonCenterViewController.h"
@interface PraiseViewController ()
@property (nonatomic,assign) int currentOffset;
@end

@implementation PraiseViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        praisePersonArr = [@[] mutableCopy];
        _currentOffset = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Methods
- (void)initUI
{
    praisePersonArr = [[NSMutableArray alloc] init];
    self.title = [NSString stringWithFormat:@"%i人觉得很赞",[praisePersonArr count]];
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_praisePersonListTableView registerNibWithName:@"MyGoodFriendsListCell" reuseIdentifier:@"Cell"];
    [_praisePersonListTableView clearSeperateLine];
    
    __weak PraiseViewController * weakSelf = self;
    [_praisePersonListTableView addHeaderWithCallback:^{
        [weakSelf refresh];
    }];
    
    [_praisePersonListTableView addFooterWithCallback:^{
        [weakSelf loadMore];
    }];
    
    [_praisePersonListTableView headerBeginRefreshing];
    
}


- (void)refresh
{
    _currentOffset = 0;
    [self getLikeUsers];
}

- (void)loadMore
{
    _currentOffset = [praisePersonArr count];
    [self getLikeUsers];
}


- (void)getLikeUsers
{
    [[HttpService sharedInstance] getLikingList:@{@"rid":_record.rid,@"offset":[NSString stringWithFormat:@"%i",_currentOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize]} completionBlock:^(id object) {
        [_praisePersonListTableView headerEndRefreshing];
        [_praisePersonListTableView footerEndRefreshing];
        [praisePersonArr addObjectsFromArray:object];
        [_praisePersonListTableView reloadData];
        
        self.title = [NSString stringWithFormat:@"%i人觉得很赞",[praisePersonArr count]];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        [_praisePersonListTableView headerEndRefreshing];
        [_praisePersonListTableView footerEndRefreshing];
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
    return [praisePersonArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    MyGoodFriendsListCell *cell = (MyGoodFriendsListCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    LikeUser * likeUser = [praisePersonArr objectAtIndex:indexPath.row];
    [cell.headPicView sd_setImageWithURL:[NSURL URLWithString:likeUser.avatar] placeholderImage:[UIImage imageNamed:@"user_touxiang"]];
    cell.nickNameLabel.text = likeUser.username;
    cell.countOfBabyLabel.text = [NSString stringWithFormat:@"%@个宝宝",likeUser.baby_count];
    cell.remarksLabel.hidden = YES;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    LikeUser * likeUser = [praisePersonArr objectAtIndex:indexPath.row];
    if(![likeUser.uid isEqualToString:users.uid])
    {
        FriendHomeViewController * vc = [[FriendHomeViewController alloc] initWithNibName:nil bundle:nil];
        vc.friendId = likeUser.uid;
        [self push:vc];
        vc = nil;
    }
    else
    {
        PersonCenterViewController * vc = [[PersonCenterViewController alloc] initWithNibName:nil bundle:nil];
        [self push:vc];
        vc = nil;
    }

}
@end
