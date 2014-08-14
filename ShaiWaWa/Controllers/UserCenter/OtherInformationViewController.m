//
//  OtherInformationViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "OtherInformationViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "SendValidateMsgViewController.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"

@interface OtherInformationViewController ()

@end

@implementation OtherInformationViewController
@synthesize otherId;
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
    self.title = @"老李";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFriendButton setTitle:@"加为好友" forState:UIControlStateNormal];
    addFriendButton.frame = CGRectMake(0, 0, 60, 30);
    [addFriendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [addFriendButton addTarget:self action:@selector(sendValidateMsg) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right_addFriend = [[UIBarButtonItem alloc] initWithCustomView:addFriendButton];
    self.navigationItem.rightBarButtonItem = right_addFriend;
    
    [self babyCell];
    [self dynamicCell];
    [self goodFriendCell];
    
    
    [[HttpService sharedInstance] getUserInfo:@{@"uid":otherId} completionBlock:^(id object) {
        ;
        _otherAvatarImgView.image = [UIImage imageWithContentsOfFile:[[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]];
        _otherUserNameTextField.text = [[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"username"];
        self.title = [[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"username"];
        _otherSwwNumTextField.text = [[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"sww_number"];
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
                                                @"uid":otherId}
                              completionBlock:^(id object) {
                                  babyLabel.text = [NSString stringWithFormat:@"宝宝 (%i)",[[object objectForKey:@"result"] count]];
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
    
    [[HttpService sharedInstance] getRecordList:@{@"offset":@"0", @"pagesize":@"10",@"uid":otherId} completionBlock:^(id object) {
        if (![[object objectForKey:@"result"] isEqual:[NSNull null]]) {
            dynamicLabel.text = [NSString stringWithFormat:@"动态 (%i)",[[object objectForKey:@"result"] count]];
        }
        else
        {
            dynamicLabel.text = [NSString stringWithFormat:@"动态 (0)"];
        }
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
    goodFriendLabel.font = [UIFont systemFontOfSize:15];
    goodFriendLabel.textColor = [UIColor darkGrayColor];
    [_goodFriendButton addSubview:goodFriendLabel];
    
    [[HttpService sharedInstance] getFriendList:@{@"uid":otherId,@"offset":@"0", @"pagesize": @"10"} completionBlock:^(id object) {
        
        if (![[object objectForKey:@"result"] isEqual:[NSNull null]]) {
            goodFriendLabel.text = [NSString stringWithFormat:@"好友 (%i)",[[object objectForKey:@"result"] count]];
        }
        else
        {
            goodFriendLabel.text = [NSString stringWithFormat:@"动态 (0)"];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
//    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
//    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
//    jianTou.frame = CGRectMake(_goodFriendButton.bounds.size.width-18, 15, 7, 11);
//    [_goodFriendButton addSubview:jianTou];
}

- (void)sendValidateMsg
{
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    
    SendValidateMsgViewController *validateMsg = [[SendValidateMsgViewController alloc] init];
    validateMsg.unfamiliarId = users.uid;
    [self.navigationController pushViewController:validateMsg animated:YES];
}
@end
