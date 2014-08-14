//
//  FriendHomeViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "FriendHomeViewController.h"
#import "UIViewController+BarItemAdapt.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
@interface FriendHomeViewController ()
{
    NSMutableArray *babyList;
}
@end

@implementation FriendHomeViewController
@synthesize friendId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    isDelBtnShown = NO;
    self.title = @"老李";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UIBarButtonItem *right_doWith= nil;
    if ([OSHelper iOS7])
    {
        right_doWith = [self customBarItem:@"user_gengduo" action:@selector(showDelButton) size:CGSizeMake(38, 30) imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
        
    }
    else
    {
        right_doWith = [self customBarItem:@"user_gengduo" action:@selector(showDelButton)];
    }
    self.navigationItem.rightBarButtonItem = right_doWith;
    delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setImage:[UIImage imageNamed:@"user_shanchu"] forState:UIControlStateNormal];
    delBtn.frame = CGRectMake(self.navigationController.navigationBar.bounds.size.width-90, self.navigationController.navigationBar.bounds.size.height+10, 84, 41);
    [delBtn addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
    
    [self babyCell];
    [self dynamicCell];
    [self goodFriendCell];
    
    
    [[HttpService sharedInstance] getUserInfo:@{@"uid":friendId} completionBlock:^(id object) {
        _friendAvatarImgView.image = [UIImage imageWithContentsOfFile:[object objectForKey:@"avatar"]];
        _friendUserNameTextField.text = [object objectForKey:@"username"];
        _friendSwwNumTextField.text = [object objectForKey:@"sww_number"];
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    
}

- (void)babyCell
{
    UILabel *babyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _babyButton.bounds.size.height-10)];
    babyLabel.backgroundColor = [UIColor clearColor];
    babyLabel.font = [UIFont systemFontOfSize:15];
    babyLabel.textColor = [UIColor darkGrayColor];
    [_babyButton addSubview:babyLabel];
    
    [[HttpService sharedInstance] getBabyList:@{@"offset":@"0",
                                                @"pagesize":@"10",
                                                @"uid":friendId}
                              completionBlock:^(id object) {
                                  
                                  babyList = [object objectForKey:@"result"];
                                  babyLabel.text = [NSString stringWithFormat:@"宝宝 (%i)",[babyList count]];
                              } failureBlock:^(NSError *error, NSString *responseString) {
                                  NSString * msg = responseString;
                                  if (error) {
                                      msg = @"加载失败";
                                  }
                                  [SVProgressHUD showErrorWithStatus:msg];
                              }];
    
    
//    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
//    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
//    jianTou.frame = CGRectMake(_babyButton.bounds.size.width-18, 15, 7, 11);
//    [_babyButton addSubview:jianTou];
}

- (void)dynamicCell
{
    UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _dynamicButton.bounds.size.height-10)];
    dynamicLabel.backgroundColor = [UIColor clearColor];
    dynamicLabel.font = [UIFont systemFontOfSize:15];
    dynamicLabel.textColor = [UIColor darkGrayColor];
    [_dynamicButton addSubview:dynamicLabel];
    
    [[HttpService sharedInstance] getRecordList:@{@"offset":@"0", @"pagesize":@"10",@"uid":friendId} completionBlock:^(id object) {
        dynamicLabel.text = [NSString stringWithFormat:@"动态 (%i)",[object count]];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
//    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
//    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
//    jianTou.frame = CGRectMake(_dynamicButton.bounds.size.width-18, 15, 7, 11);
//    [_dynamicButton addSubview:jianTou];
}

- (void)goodFriendCell
{
    UILabel *goodFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _goodFriendButton.bounds.size.height-10)];
    goodFriendLabel.backgroundColor = [UIColor clearColor];
    goodFriendLabel.text = [NSString stringWithFormat:@"好友 (%i)",32];
    goodFriendLabel.font = [UIFont systemFontOfSize:15];
    goodFriendLabel.textColor = [UIColor darkGrayColor];
    [_goodFriendButton addSubview:goodFriendLabel];
    
//    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
//    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
//    jianTou.frame = CGRectMake(_goodFriendButton.bounds.size.width-18, 15, 7, 11);
//    [_goodFriendButton addSubview:jianTou];
}
- (void)showDelButton
{
    if (!isDelBtnShown) {
        [self.navigationController.view addSubview:delBtn];
        isDelBtnShown = YES;
    }
    else
    {
        [delBtn removeFromSuperview];
        isDelBtnShown = NO;
    }
}
- (void)deleteFriend
{
    UserInfo * users = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] deleteFriend:@{@"uid":users.uid,@"friend_id":friendId} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
}

@end
