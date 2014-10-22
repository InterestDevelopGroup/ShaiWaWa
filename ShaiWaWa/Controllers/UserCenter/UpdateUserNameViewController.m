//
//  UpdateUserNameViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
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
    
    if([_userNameField.text length] == 0)
    {
        return ;
    }
    
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    if([_userNameField.text isEqualToString:user.username])
    {
        return ;
    }
    
    user.username = _userNameField.text;
    [[HttpService sharedInstance] updateUserInfo:@{@"user_id":user.uid,@"username":user.username,@"avatar":user.avatar,@"sex":user.sex,@"qq":user.qq,@"weibo":user.weibo,@"wechat":user.wechat} completionBlock:^(id object) {
         [SVProgressHUD showSuccessWithStatus:@"更新成功"];
         [[UserDefault sharedInstance] setUserInfo:user];
         [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    
    
    
    
}
@end
