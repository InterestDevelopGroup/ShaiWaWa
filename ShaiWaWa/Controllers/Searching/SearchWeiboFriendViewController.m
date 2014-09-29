//
//  SearchWeiboFriendViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//
#import "SearchWeiboFriendViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "WeiboUser.h"
#import "UIImageView+WebCache.h"
#import "AppMacros.h"
@interface SearchWeiboFriendViewController ()
@property (nonatomic,strong) NSMutableArray * isAuthFriends;
@property (nonatomic,strong) NSMutableArray * unAuthFriends;
@property (nonatomic,strong) NSMutableArray * allFriends;
@property (nonatomic,assign) int currentOffset;
@end

@implementation SearchWeiboFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isAuthFriends = [@[] mutableCopy];
        _unAuthFriends = [@[] mutableCopy];
        _allFriends = [@[] mutableCopy];
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
    self.title = @"查找微博好友";
    [self setLeftCusBarItem:@"square_back" action:nil];
    sectionArr = [[NSArray alloc] initWithObjects:@"待关注好友",@"可邀请好友", nil];


    [_weiBoListTableView clearSeperateLine];
    [_weiBoListTableView registerNibWithName:@"WeiBoCell" reuseIdentifier:@"Cell"];
    
    __weak SearchWeiboFriendViewController * weakSelf = self;
    [_weiBoListTableView addHeaderWithCallback:^{
        [weakSelf refresh];
    }];
    
    [_weiBoListTableView addFooterWithCallback:^{
        [weakSelf loadMore];
    }];
    
    [_weiBoListTableView headerBeginRefreshing];
}

- (void)refresh
{
    _currentOffset = 1;
    [self getWeiBoFriends];
}

- (void)loadMore
{
    _currentOffset = [_allFriends count] + 1;
    [self getWeiBoFriends];
}


- (void)getWeiBoFriends
{
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    NSString * token = [[NSUserDefaults standardUserDefaults] objectForKey:@"SIAN_ACCESS_TOKEN"];
    [[HttpService sharedInstance] getSinaFriend:@{@"uid":user.uid,@"access_token":token,@"offset":[NSString stringWithFormat:@"%i",_currentOffset],@"pagesize":@"200"} completionBlock:^(id object) {
        
        [_weiBoListTableView headerEndRefreshing];
        [_weiBoListTableView footerEndRefreshing];
        
        if(object != nil && [object count] > 0)
        {
            [_allFriends addObjectsFromArray:object];
            for(WeiboUser * user in object)
            {
                if([user.is_auth isEqualToString:@"0"])
                {
                    [_unAuthFriends addObject:user];
                }
                else
                {
                    [_isAuthFriends addObject:user];
                }
            }
            
            [_weiBoListTableView reloadData];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        [_weiBoListTableView headerEndRefreshing];
        [_weiBoListTableView footerEndRefreshing];
        
        NSString * msg = responseString;
        if(error)
        {
            msg = @"获取失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)btnSelected:(UIButton *)button
{
    WeiBoCell * cell ;
    if([button.superview.superview.superview isKindOfClass:[WeiboUser class]])
    {
        cell = (WeiBoCell *)button.superview.superview.superview;
    }
    else if([button.superview.superview isKindOfClass:[WeiboUser class]])
    {
        cell = (WeiBoCell *)button.superview.superview;
    }
    else
    {
        cell = (WeiBoCell *)button.superview;
    }
    
    NSIndexPath * indexPath = [_weiBoListTableView indexPathForCell:cell];
    if(indexPath.section == 0)
    {
        WeiboUser * contact = _isAuthFriends[indexPath.row];
        UserInfo * user = [[UserDefault sharedInstance] userInfo];
        
        [[HttpService sharedInstance] applyFriend:@{@"uid":user.uid,@"friend_id":contact.uid,@"remark":@"申请好友"} completionBlock:^(id object) {
            
            [SVProgressHUD showSuccessWithStatus:@"已发送申请."];
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            NSString * msg = responseString;
            if(error)
            {
                msg = @"申请失败.";
            }
            [SVProgressHUD showErrorWithStatus:msg];
        }];
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
    if(section == 0)
    {
        return [_isAuthFriends count];
    }
    else
    {
        return [_unAuthFriends count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiBoCell * weiBoCell = (WeiBoCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    weiBoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    WeiboUser * user;
    if(indexPath.section == 0)
    {
        user = _isAuthFriends[indexPath.row];
        weiBoCell.addFriendButton.hidden = NO;
        [weiBoCell.addFriendButton addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        user = _unAuthFriends[indexPath.row];
        weiBoCell.addFriendButton.hidden = YES;
    }
    
    weiBoCell.nameLabel.text = user.name;
    [weiBoCell.touXiangImgView sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:Default_Avatar];
    
    return weiBoCell;
    
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
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
