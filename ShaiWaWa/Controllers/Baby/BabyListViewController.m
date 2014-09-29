//
//  BabyListViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BabyListViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "BabyListCell.h"
#import "BabyHomePageViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "AppMacros.h"
@interface BabyListViewController ()

@end

@implementation BabyListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"宝宝列表";
    [self setLeftCusBarItem:@"square_back" action:nil];
    sectionArr = [[NSArray alloc] initWithObjects:@"我的宝宝",@"好友宝宝",nil];
    myBabyList = [[NSArray alloc] init];
    friendsBabyList =  [[NSArray alloc] init];
    [_babyListTableView clearSeperateLine];
    [_babyListTableView registerNibWithName:@"BabyListCell" reuseIdentifier:@"Cell"];
    [_babyListTableView addHeaderWithTarget:self action:@selector(refresh)];
    [_babyListTableView setHeaderRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    [_babyListTableView headerBeginRefreshing];
}

- (void)refresh
{
    [self getBabys];
}


//获取宝宝列表
- (void)getBabys
{
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    //获取我的宝宝
    [self getMyBabysWithUid:user.uid];
}

#pragma mark - 获取往我的宝宝
- (void)getMyBabysWithUid:(NSString *)uid
{
    [[HttpService sharedInstance] getBabyList:@{@"offset":@"0",@"pagesize":@"100",@"uid":uid} completionBlock:^(id object) {
        //关闭刷新状态
//        [_babyListTableView headerEndRefreshing];
        if(object == nil || [object count] == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"您还没有添加宝宝."];
            return  ;
        }
        myBabyList = object;
        //获取我好友的宝宝
        [self getMyFriendBabysWithUid:uid];
        //刷新数据
//        [_babyListTableView reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_babyListTableView headerEndRefreshing];
    }];
}

#pragma mark - 获取往我好友的宝宝
- (void)getMyFriendBabysWithUid:(NSString *)uid
{
    [[HttpService sharedInstance] getBabyListByFriend:@{@"offset":@"0",@"pagesize":@"100",@"uid":uid} completionBlock:^(id object) {
        //关闭刷新状态
        [_babyListTableView headerEndRefreshing];
        if(object == nil || [object count] == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"您好友没有添加宝宝."];
            return  ;
        }
        friendsBabyList = object;
        //刷新数据
        [_babyListTableView reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_babyListTableView headerEndRefreshing];
    }];
}

#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sectionArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 获取当前section的名称，据此获取到当前section的数量。
    if (section == 0) {
        return [myBabyList count];
    }
    return [friendsBabyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BabyListCell * babyListCell = (BabyListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    BabyInfo * baby = nil;
    if (indexPath.section == 0) {
       baby = myBabyList[indexPath.row];
    }else
    {
        baby = friendsBabyList[indexPath.row];
    }
    
    babyListCell.babyNameLabel.text = baby.nickname;
    
    [babyListCell.babyImage sd_setImageWithURL:[NSURL URLWithString:baby.avatar] placeholderImage:Default_Avatar];

    if([baby.sex isEqualToString:@"0"])
    {
        //保密
        babyListCell.babySexImage.hidden = YES;
    }
    else if([baby.sex isEqualToString:@"1"])
    {
        //男
        babyListCell.babySexImage.hidden = NO;
        babyListCell.babySexImage.image = [UIImage imageNamed:@"main_boy.png"];
    }
    else if([baby.sex isEqualToString:@"2"])
    {
        //女
        babyListCell.babySexImage.hidden = NO;
        babyListCell.babySexImage.image = [UIImage imageNamed:@"main_girl.png"];
    }

    
    return babyListCell;
    
}

// 这个方法用来告诉表格第section分组的名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionType = [sectionArr objectAtIndex:section];
    return sectionType;
    
}

// 设置section标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

#pragma mark - 点击cell的监听方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BabyHomePageViewController *babyHomePageVC = [[BabyHomePageViewController alloc] initWithNibName:nil bundle:nil];
    BabyInfo * babyInfo = nil;
    if (indexPath.section == 0) {
       babyInfo = myBabyList[indexPath.row];
    }else
    {
        babyInfo = friendsBabyList[indexPath.row];
    }
    babyHomePageVC.babyInfo = babyInfo;
    [self.navigationController pushViewController:babyHomePageVC animated:YES];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
