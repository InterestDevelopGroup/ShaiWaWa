//
//  SetPasswordStepOneViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-9-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SetPasswordStepOneViewController.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "SVProgressHUD.h"
#import "HttpService.h"
#import "PostValidateViewController.h"
#import "UIViewController+BarItemAdapt.h"
@interface SetPasswordStepOneViewController ()

@end

@implementation SetPasswordStepOneViewController

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
    self.title = @"发送验证码";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    _phoneLabel.text = user.phone;
}

- (IBAction)nextAction:(id)sender
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    
    NSString * phone = user.phone;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[HttpService sharedInstance] sendValidateCode:@{@"phone":phone} completionBlock:^(id object)
    {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SendSuccess", nil)];
        PostValidateViewController * vc = [[PostValidateViewController alloc] initWithNibName:nil bundle:nil];
        vc.currentPhone = phone;
        vc.isBinding = YES;
        vc.type = @"2";
        [self push:vc];
        vc = nil;
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        NSString * msg = responseString;
        if(error != nil)
        {
            msg = NSLocalizedString(@"SendError", nil);
        }
        
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
@end
