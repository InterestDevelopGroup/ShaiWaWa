//
//  FriendHomeViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "FriendHomeViewController.h"
#import "UIViewController+BarItemAdapt.h"
@interface FriendHomeViewController ()

@end

@implementation FriendHomeViewController

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
    
    [self babyCell];
    [self dynamicCell];
    [self goodFriendCell];
}

- (void)babyCell
{
    UILabel *babyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _babyButton.bounds.size.height-10)];
    babyLabel.backgroundColor = [UIColor clearColor];
    babyLabel.text = [NSString stringWithFormat:@"宝宝 (%i)",2];
    babyLabel.font = [UIFont systemFontOfSize:15];
    babyLabel.textColor = [UIColor darkGrayColor];
    [_babyButton addSubview:babyLabel];
    
//    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
//    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
//    jianTou.frame = CGRectMake(_babyButton.bounds.size.width-18, 15, 7, 11);
//    [_babyButton addSubview:jianTou];
}

- (void)dynamicCell
{
    UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _dynamicButton.bounds.size.height-10)];
    dynamicLabel.backgroundColor = [UIColor clearColor];
    dynamicLabel.text = [NSString stringWithFormat:@"动态 (%i)",28];
    dynamicLabel.font = [UIFont systemFontOfSize:15];
    dynamicLabel.textColor = [UIColor darkGrayColor];
    [_dynamicButton addSubview:dynamicLabel];
    
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
@end
