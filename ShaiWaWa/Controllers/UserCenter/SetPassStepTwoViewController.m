//
//  SetPassStepTwoViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-9-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SetPassStepTwoViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "InputHelper.h"
#import "SVProgressHUD.h"
#import "HttpService.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "PlatformBindViewController.h"
@interface SetPassStepTwoViewController ()

@end

@implementation SetPassStepTwoViewController

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

- (void)initUI
{
    self.title = @"设置密码";
    [self setLeftCusBarItem:@"square_back" action:@selector(backAction:)];
}


- (void)backAction:(id)sender
{
    NSArray * vcs = self.navigationController.viewControllers;
    for(UIViewController * vc in vcs)
    {
        if([vc isKindOfClass:[PlatformBindViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            break ;
        }
    }
}

- (IBAction)finishAction:(id)sender
{
    NSString * pass = [InputHelper trim:_passField.text];
    if([InputHelper isEmpty:pass])
    {
        [SVProgressHUD showErrorWithStatus:@"密码不能为空."];
        return ;
    }
    
    if(![InputHelper minLength:6 withString:pass])
    {
        [SVProgressHUD showErrorWithStatus:@"密码太短."];
        return;
    }
    
    if(![InputHelper maxLength:10 withString:pass])
    {
        [SVProgressHUD showErrorWithStatus:@"密码不能超出10个字符."];
        return ;
    }
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] changePassword:@{@"user_id":user.uid,@"origin_password":user.password == nil ? @"":user.password,@"password":pass} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"设置成功"];
        _passField.text = @"";
        [self backAction:nil];
        //[self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
}
@end
