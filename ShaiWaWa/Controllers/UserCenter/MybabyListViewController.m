//
//  MybabyViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MybabyListViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "BabyListCell.h"
#import "BabyHomePageViewController.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"

#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"

#import "AppMacros.h"
#import "UIImageView+WebCache.h"

@interface MybabyListViewController ()
{
    NSMutableArray *myBabyList;
}
@property (nonatomic,assign) int currentOffset;
@end

@implementation MybabyListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currentOffset = 0;
        myBabyList = [@[] mutableCopy];
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
    self.title = @"我的宝宝";
    
    if(_user == nil)
    {
        _user = [[UserDefault sharedInstance] userInfo];
    }
    else
    {
        self.title = [NSString stringWithFormat:@"%@的宝宝",_user.username];
    }
    
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_babyListTableView clearSeperateLine];
    [_babyListTableView registerNibWithName:@"BabyListCell" reuseIdentifier:@"Cell"];
    __weak MybabyListViewController * weakSelf = self;
    [_babyListTableView addHeaderWithCallback:^{
        [weakSelf refresh];
    }];
    
    [_babyListTableView addFooterWithCallback:^{
        [weakSelf loadMore];
    }];

    [_babyListTableView headerBeginRefreshing];
}

- (void)refresh
{
    _currentOffset= 0;
    [self getBabys];
}

- (void)loadMore
{
    _currentOffset = [myBabyList count];
    [self getBabys];
}

//获取宝宝列表
- (void)getBabys
{

    [[HttpService sharedInstance] getBabyList:@{@"offset":[NSString stringWithFormat:@"%i",_currentOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"uid":_user.uid}completionBlock:^(id object) {
        
        [_babyListTableView headerEndRefreshing];
        [_babyListTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            if(object == nil || [object count] == 0)
            {
                [SVProgressHUD showErrorWithStatus:@"您还没有添加宝宝."];
                return ;
            }
            myBabyList = (NSMutableArray *)object;
        }
        else
        {
            [myBabyList addObjectsFromArray:object];
        }
        
        [_babyListTableView reloadData];
        //[SVProgressHUD showSuccessWithStatus:@"获取成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        [_babyListTableView headerEndRefreshing];
        [_babyListTableView footerEndRefreshing];
        NSString * msg = responseString;
        if (error) {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myBabyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BabyListCell * babyListCell = (BabyListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    BabyInfo * baby = myBabyList[indexPath.row];
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

    babyListCell.focusImageView.hidden = YES;
    return babyListCell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_babyListTableView deselectRowAtIndexPath:indexPath animated:YES];
    BabyHomePageViewController *babyHomePageVC = [[BabyHomePageViewController alloc] initWithNibName:nil bundle:nil];
    BabyInfo * babyInfo = [myBabyList objectAtIndex:indexPath.row];
    
    if(self.didSelectBaby)
    {
        self.didSelectBaby(babyInfo);
        [self popVIewController];
        return ;
    }
    
    
    NSInteger timeInterval = [[NSDate dateFromString:babyInfo.birthday withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
    babyInfo.birthday = [NSString stringWithFormat:@"%d",timeInterval];
    babyHomePageVC.babyInfo = babyInfo;
    [self.navigationController pushViewController:babyHomePageVC animated:YES];
    
}
@end
