//
//  PersonCenterViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PersonCenterViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "ControlCenter.h"
#import "PlatformBindViewController.h"
#import "MyGoodFriendsListViewController.h"
#import "MybabyListViewController.h"
#import "QRCodeCardViewController.h"

#import "UserDefault.h"


@interface PersonCenterViewController ()

@end

@implementation PersonCenterViewController

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
    users = [[UserDefault sharedInstance] userInfo];
    self.title = users.username;
    [self setLeftCusBarItem:@"square_back" action:nil];
    [self babyCell];
    [self dynamicCell];
    [self goodFriendCell];
    [self twoDimensionCodeCell];
    [self myCollectionCell];
    [self socialPlatformBindCell];
    
}

- (void)babyCell
{
    UILabel *babyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _babyButton.bounds.size.height-10)];
    babyLabel.backgroundColor = [UIColor clearColor];
    babyLabel.text = [NSString stringWithFormat:@"宝宝 (%i)",2];
    babyLabel.font = [UIFont systemFontOfSize:15];
    babyLabel.textColor = [UIColor darkGrayColor];
    [_babyButton addSubview:babyLabel];
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_babyButton.bounds.size.width-18, 15, 7, 11);
    [_babyButton addSubview:jianTou];
}

- (void)dynamicCell
{
    UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _dynamicButton.bounds.size.height-10)];
    dynamicLabel.backgroundColor = [UIColor clearColor];
    dynamicLabel.text = [NSString stringWithFormat:@"动态 (%i)",28];
    dynamicLabel.font = [UIFont systemFontOfSize:15];
    dynamicLabel.textColor = [UIColor darkGrayColor];
    [_dynamicButton addSubview:dynamicLabel];
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_dynamicButton.bounds.size.width-18, 15, 7, 11);
    [_dynamicButton addSubview:jianTou];
}

- (void)goodFriendCell
{
    UILabel *goodFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _goodFriendButton.bounds.size.height-10)];
    goodFriendLabel.backgroundColor = [UIColor clearColor];
    goodFriendLabel.text = [NSString stringWithFormat:@"好友 (%i)",32];
    goodFriendLabel.font = [UIFont systemFontOfSize:15];
    goodFriendLabel.textColor = [UIColor darkGrayColor];
    [_goodFriendButton addSubview:goodFriendLabel];
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_goodFriendButton.bounds.size.width-18, 15, 7, 11);
    [_goodFriendButton addSubview:jianTou];
}

- (void)twoDimensionCodeCell
{
    UILabel *twoDimensionCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _twoDimensionCodeButton.bounds.size.height-10)];
    twoDimensionCodeLabel.backgroundColor = [UIColor clearColor];
    twoDimensionCodeLabel.text = [NSString stringWithFormat:@"二维码名片"];
    twoDimensionCodeLabel.font = [UIFont systemFontOfSize:15];
    twoDimensionCodeLabel.textColor = [UIColor darkGrayColor];
    [_twoDimensionCodeButton addSubview:twoDimensionCodeLabel];
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_twoDimensionCodeButton.bounds.size.width-18, 15, 7, 11);
    [_twoDimensionCodeButton addSubview:jianTou];
}

- (void)myCollectionCell
{
    UILabel *myCollectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _myCollectionButton.bounds.size.height-10)];
    myCollectionLabel.backgroundColor = [UIColor clearColor];
    myCollectionLabel.text = [NSString stringWithFormat:@"我的收藏 (%i)",21];
    myCollectionLabel.font = [UIFont systemFontOfSize:15];
    myCollectionLabel.textColor = [UIColor darkGrayColor];
    [_myCollectionButton addSubview:myCollectionLabel];
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_myCollectionButton.bounds.size.width-18, 15, 7, 11);
    [_myCollectionButton addSubview:jianTou];
}

- (void)socialPlatformBindCell
{
    UILabel *socialPlatformBindLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _sheJianBar.bounds.size.height-10)];
    socialPlatformBindLabel.backgroundColor = [UIColor clearColor];
    socialPlatformBindLabel.text = [NSString stringWithFormat:@"社交平台绑定"];
    socialPlatformBindLabel.font = [UIFont systemFontOfSize:15];
    socialPlatformBindLabel.textColor = [UIColor darkGrayColor];
    [_sheJianBar addSubview:socialPlatformBindLabel];
    
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_sheJianBar.bounds.size.width-18, 15, 7, 11);
    [_sheJianBar addSubview:jianTou];
}

- (IBAction)showUserInfoPageVC:(id)sender
{
    [ControlCenter pushToUserInfoPageVC];
}

- (IBAction)showPlatformBind:(id)sender
{
    PlatformBindViewController *platformVC = [[PlatformBindViewController alloc] init];
    [self.navigationController pushViewController:platformVC animated:YES];
}
- (IBAction)changeImg:(id)sender {
}

- (IBAction)showGoodFriendListVC:(id)sender
{
    MyGoodFriendsListViewController *myGoodFriendListVC = [[MyGoodFriendsListViewController alloc] init];
    [self.navigationController pushViewController:myGoodFriendListVC animated:YES];
}

- (IBAction)showMyBabyListVC:(id)sender
{
    MybabyListViewController *myBabyListVC = [[MybabyListViewController alloc] init];
    [self.navigationController pushViewController:myBabyListVC animated:YES];
}

- (IBAction)showMyQRCardVC:(id)sender
{
    QRCodeCardViewController *qrCodeCardVC = [[QRCodeCardViewController alloc] init];
    [self.navigationController pushViewController:qrCodeCardVC animated:YES];
}
@end
