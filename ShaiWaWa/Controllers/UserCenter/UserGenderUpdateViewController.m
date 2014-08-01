//
//  UserGenderUpdateViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UserGenderUpdateViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
@interface UserGenderUpdateViewController ()

@end

@implementation UserGenderUpdateViewController

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
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:YES];
//    if ([[[[UserDefault sharedInstance] userInfo] sex] isEqual:[NSNull null]]) {
//        [self secureSelected:nil];
//    }
//    if ([[[[UserDefault sharedInstance] userInfo] sex] isEqualToString:@"1"]) {
//        [self manSelected:nil];
//    }
//    if ([[[[UserDefault sharedInstance] userInfo] sex] isEqualToString:@"2"]) {
//        [self womanSelected:nil];
//    }
//}

#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"性别";
    [self setLeftCusBarItem:@"square_back" action:nil];
    if ([[[[UserDefault sharedInstance] userInfo] sex] isEqualToString:@"0"]) {
        [self secureSelected:nil];
    }
    if ([[[[UserDefault sharedInstance] userInfo] sex] isEqualToString:@"1"]) {
        [self manSelected:nil];
    }
    if ([[[[UserDefault sharedInstance] userInfo] sex] isEqualToString:@"2"]) {
        [self womanSelected:nil];
    }
//    isSecure = NO;
//    isMan = NO;
//    isWoman = NO;
    
}
- (IBAction)secureSelected:(id)sender
{
    isSecure = YES;
    isMan = NO;
    isWoman = NO;
    [_secureButton setImage:[UIImage imageNamed:@"main_dian.png"] forState:UIControlStateNormal];
    [_manButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
    [_womanButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
}

- (IBAction)manSelected:(id)sender
{
    isSecure = NO;
    isMan = YES;
    isWoman = NO;
    [_secureButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
    [_manButton setImage:[UIImage imageNamed:@"main_dian.png"] forState:UIControlStateNormal];
    [_womanButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
}

- (IBAction)womanSelected:(id)sender
{
    isSecure = NO;
    isMan = NO;
    isWoman = YES;
    [_secureButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
    [_manButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
    [_womanButton setImage:[UIImage imageNamed:@"main_dian.png"] forState:UIControlStateNormal];
}

- (IBAction)update_ok:(id)sender
{
    UserInfo *curUser = [[UserInfo alloc] init];
    curUser.phone = [[[UserDefault sharedInstance] userInfo] phone];
    curUser.username = [[[UserDefault sharedInstance] userInfo] username];
    curUser.password = [[[UserDefault sharedInstance] userInfo] password];
    curUser.uid = [[[UserDefault sharedInstance] userInfo] uid];
    
    if (isSecure) {
        curUser.sex = @"0";
    }
    if (isMan) {
        curUser.sex = @"1";
    }
    if (isWoman) {
        curUser.sex = @"2";
    }
    
    
    curUser.sww_number = [[[UserDefault sharedInstance] userInfo] sww_number];
    NSLog(@"%@",@{@"user_id":curUser.uid,@"username":curUser.username,@"avatar":[NSNull null],@"sex":@"1",@"qq":[NSNull null],@"weibo":[NSNull null],@"wechat":[NSNull null]});
    [[HttpService sharedInstance] updateUserInfo:@{@"user_id":curUser.uid,@"username":curUser.username,@"avatar":[NSNull null],@"sex":curUser.sex,@"qq":[NSNull null],@"weibo":[NSNull null],@"wechat":[NSNull null]} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"更新成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    
    
    
}
@end
