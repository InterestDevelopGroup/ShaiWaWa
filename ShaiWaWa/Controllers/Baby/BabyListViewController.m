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
@property (nonatomic,strong) NSString * keyword;
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
    [self setRightCustomBarItem:@"user_gengduo" action:@selector(edit:)];
    sectionArr = [[NSArray alloc] initWithObjects:@"我的宝宝",@"好友宝宝",nil];
    myBabyList = [[NSMutableArray alloc] init];
    friendsBabyList =  [[NSMutableArray alloc] init];
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
    //获取我好友的宝宝
    [self getMyFriendBabysWithUid:user.uid];
}

#pragma mark - 获取往我的宝宝
- (void)getMyBabysWithUid:(NSString *)uid
{

    [[HttpService sharedInstance] getBabyList:@{@"offset":@"0",@"pagesize":@"10000",@"uid":uid} completionBlock:^(id object) {
        [_babyListTableView headerEndRefreshing];

        if(object == nil || [object count] == 0)
        {
            [SVProgressHUD showErrorWithStatus:@"您还没有添加宝宝."];
            return  ;
        }
        myBabyList = object;
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

#pragma mark - 获取往我好友的宝宝
- (void)getMyFriendBabysWithUid:(NSString *)uid
{

    [[HttpService sharedInstance] getBabyListByFriend:@{@"offset":@"0",@"pagesize":@"10000",@"uid":uid} completionBlock:^(id object) {

        [_babyListTableView headerEndRefreshing];
        if(object == nil || [object count] == 0)
        {
            //[SVProgressHUD showErrorWithStatus:@"您好友没有添加宝宝."];
            return  ;
        }
        friendsBabyList = object;
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

- (void)filterBabys
{
    if(_keyword == nil || [_keyword length] == 0)
    {
        //重新获取宝宝
        [self getBabys];
    }
    else
    {
        NSMutableArray * arr_1, * arr_2;
        arr_1 = [@[] mutableCopy];
        arr_2 = [@[] mutableCopy];
        for(BabyInfo * baby in myBabyList)
        {
            NSRange range_1 = [baby.nickname rangeOfString:_keyword];
            NSRange range_2 = [baby.baby_name rangeOfString:_keyword];
            
            if(range_1.location != NSNotFound || range_2.location != NSNotFound)
            {
                [arr_1 addObject:baby];
            }
        }
        
        myBabyList = arr_1;
        
        for(BabyInfo * baby in friendsBabyList)
        {
            NSRange range_1 = [baby.nickname rangeOfString:_keyword];
            NSRange range_2 = [baby.baby_name rangeOfString:_keyword];
            
            if(range_1.location != NSNotFound || range_2.location != NSNotFound)
            {
                [arr_2 addObject:baby];
            }
        }
        
        friendsBabyList = arr_2;
        
        [_babyListTableView reloadData];

    }
}

#pragma mark 右上角按钮方法监听
- (void)edit:(UIButton *)btn
{
    [btn setSelected:!btn.selected];
    if (btn.selected) {
        
        [self.babyListTableView setEditing:YES animated:YES];
    }else
    {
        [self.babyListTableView setEditing:NO animated:YES];
    }
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

    babyListCell.babyOldLabel.text = [NSString stringWithFormat:@"%@条动态",baby.record_count];
    
    if([baby.is_focus isEqualToString:@"0"])
    {
        babyListCell.focusImageView.hidden = YES;
    }
    else
    {
        babyListCell.focusImageView.hidden = NO;
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

    BabyInfo * babyInfo ;
    if(indexPath.section == 0)
    {
        babyInfo = myBabyList[indexPath.row];
    }
    else
    {
        babyInfo = friendsBabyList[indexPath.row];
    }
    
    babyHomePageVC.babyInfo = babyInfo;
    [self.navigationController pushViewController:babyHomePageVC animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(UITableViewCellEditingStyleDelete != editingStyle)
    {
        return ;
    }
    //调用网络删除宝宝借口
    UserInfo * users = [[UserDefault sharedInstance] userInfo];
    BabyInfo * b = myBabyList[indexPath.row];
    [[HttpService sharedInstance] deleteBaby:@{@"uid":users.uid,@"baby_id":b.baby_id} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [myBabyList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"删除失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _keyword = textField.text;
    [self filterBabys];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 搜索宝宝按钮的监听
- (IBAction)searchBaby:(id)sender {
    [self.view endEditing:YES];
    _keyword = _searchText.text;
    [self filterBabys];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self getBabys];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//    if (_searchText.text.length == 0) {
//        [self getBabys];
//        [self.view endEditing:YES];
//    }
//    return YES;
//}



@end
