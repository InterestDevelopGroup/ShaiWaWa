//
//  PostValidateViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PostValidateViewController.h"
#import "ControlCenter.h"
#import "UIViewController+BarItemAdapt.h"
#import "SearchAddressListViewController.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"

@interface PostValidateViewController ()

@end

@implementation PostValidateViewController

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
    self.title = @"提交验证码";
    [self setLeftCusBarItem:@"square_back" action:nil];
    myDelegate = [[UIApplication sharedApplication] delegate];
    _phoneNumberLabel.text = myDelegate.postValidatePhoneNum;
    if (myDelegate.postValidateCoreTime != nil) {
        countBacki = [myDelegate.postValidateCoreTime intValue];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countBackwards) userInfo:nil repeats:YES];
    }
    else
    {
    countBacki = 60;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countBackwards) userInfo:nil repeats:YES];
      
    }
}


- (void)countBackwards
{
    countBacki--;
    [_getCoreAgainButton setBackgroundImage:[UIImage imageNamed:@"login_box-5.png"] forState:UIControlStateNormal];
    myDelegate.postValidateCoreTime = [NSString stringWithFormat:@"%d",countBacki];
    [_getCoreAgainButton setTitle:[NSString stringWithFormat:@"重发(%d)",countBacki] forState:UIControlStateNormal];
    if (countBacki == 0) {
        [timer invalidate];
        timer = nil;
        myDelegate.postValidateCoreTime = nil;
        [_getCoreAgainButton setTitle:[NSString stringWithFormat:@"重发"] forState:UIControlStateNormal];
        [_getCoreAgainButton setBackgroundImage:[UIImage imageNamed:@"login_box3.png"] forState:UIControlStateNormal];
         _getCoreAgainButton.enabled = YES;
        
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)showFinishRegisterVC:(id)sender
{
    [_validateCoreTextField resignFirstResponder];
    if ([myDelegate.postValidateType isEqualToString:@"reg"]) {
        if (_validateCoreTextField.text.length > 0) {
            if (_validateCoreTextField.text.length == 6) {
                myDelegate.postValidateCore = _validateCoreTextField.text;
                [ControlCenter pushToFinishRegisterVC];
                 _validateCoreTextField.text = nil;
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"输入验证码格式有误"];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"文本框不能为空"];
        }
       
    }
    else if ([myDelegate.postValidateType isEqualToString:@"addrBook"])
    {
        
        if (_validateCoreTextField.text.length > 0) {
            if (_validateCoreTextField.text.length == 6) {
                myDelegate.postValidateCore = _validateCoreTextField.text;
                SearchAddressListViewController *addressListVC = [[SearchAddressListViewController alloc] init];
                [self.navigationController pushViewController:addressListVC animated:YES];
                _validateCoreTextField.text = nil;
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:@"输入验证码格式有误"];
            }
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"文本框不能为空"];
        }

    }
    else
    {
    
    }
   
}
- (IBAction)getCoreAgainEvent:(id)sender
{
    
    if (myDelegate.postValidateCoreTime != nil) {
        [SVProgressHUD showErrorWithStatus:@"一分钟内不可重复获取"];
    }
    else
    {
    [[HttpService sharedInstance] sendValidateCode:@{@"phone":myDelegate.postValidatePhoneNum} completionBlock:^(id object) {
        countBacki = 60;
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countBackwards) userInfo:nil repeats:YES];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    }
}
@end
