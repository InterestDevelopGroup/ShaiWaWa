//
//  BindUserViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-9-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BindUserViewController.h"
#import "HttpService.h"
#import "UserInfo.h"
#import "SVProgressHUD.h"
#import "InputHelper.h"
#import "ChooseModeViewController.h"
@interface BindUserViewController ()

@end

@implementation BindUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"绑定账号";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)bindAction:(id)sender
{
    [self.view endEditing:YES];
    [self resignFirstResponder];
    NSString * phone = [InputHelper trim:_phoneField.text];
    NSString * pass = [InputHelper trim:_passField.text];
    if([InputHelper isEmpty:phone])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入手机号码"];
        return ;
    }
    
    if(![InputHelper isPhone:phone])
    {
        [SVProgressHUD showErrorWithStatus:@"手机号码无效."];
        return ;
    }
    
    if([InputHelper isEmpty:pass])
    {
        [SVProgressHUD showErrorWithStatus:@"请输入密码."];
        return ;
    }
    
    
    [[HttpService sharedInstance] userLogin:@{@"phone":phone,@"password":pass,@"open_id":_token,@"type":_type} completionBlock:^(id object) {
        
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"登陆失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


- (void)showChooseModeVC
{
    ChooseModeViewController *chooseModeVC = [[ChooseModeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:chooseModeVC animated:YES];
}

@end
