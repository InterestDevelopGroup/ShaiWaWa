//
//  UpdateUserNameViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UpdateUserNameViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "UserInfoPageViewController.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
@interface UpdateUserNameViewController ()

@end

@implementation UpdateUserNameViewController
@synthesize userName;
@synthesize usernameTextBlock;
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
    self.title = @"用户名";
    [self setLeftCusBarItem:@"square_back" action:nil];
    _userNameField.text = userName;
   
}

- (IBAction)update_OK:(id)sender
{
//     usernameTextBlock(_userNameField.text);
    UserInfo *curUser = [[UserInfo alloc] init];
    curUser.phone = [[[UserDefault sharedInstance] userInfo] phone];
    curUser.username = _userNameField.text;
    curUser.password = [[[UserDefault sharedInstance] userInfo] password];
    curUser.uid = [[[UserDefault sharedInstance] userInfo] uid];
    curUser.sex = [[[UserDefault sharedInstance] userInfo] sex];
    curUser.sww_number = [[[UserDefault sharedInstance] userInfo] sww_number];
    curUser.avatar =  [[[UserDefault sharedInstance] userInfo] avatar];
    
    [[HttpService sharedInstance] updateUserInfo:@{@"user_id":curUser.uid,@"username":curUser.username,@"avatar":[NSNull null],@"sex":[NSNull null],@"qq":[NSNull null],@"weibo":[NSNull null],@"wechat":[NSNull null]} completionBlock:^(id object) {
         [SVProgressHUD showSuccessWithStatus:@"更新成功"];
         [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    
    
    
    
}
@end
