//
//  FinishRegisterViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "FinishRegisterViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "ControlCenter.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
@interface FinishRegisterViewController ()

@end

@implementation FinishRegisterViewController

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
    self.title = @"完成注册";
    [self setLeftCusBarItem:@"square_back" action:nil];
    mydelegate = [[UIApplication sharedApplication] delegate];
    
    __weak NSString *username = _userNameField.text;
    __weak NSString *pwd = _pwdField.text;
    __weak NSString *phone = mydelegate.postValidatePhoneNum;
    __weak NSString *validateCore = mydelegate.postValidateCore;
    __weak FinishRegisterViewController *finishVC = self;
    
    [self setStrBlock:^(NSString *str){
        [[HttpService sharedInstance] userRegister:@{@"username":username,@"password":pwd,@"phone":phone,@"sww_number":str,@"validate_code":validateCore} completionBlock:^(id object) {
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
            [finishVC.navigationController popToRootViewControllerAnimated:YES];
        } failureBlock:^(NSError *error, NSString *responseString) {
            [SVProgressHUD showErrorWithStatus:responseString];
        }];
    }];
}
- (IBAction)disableSecure:(id)sender
{
    [_pwdField setSecureTextEntry:NO];
}
    
- (IBAction)finishRegisterAndLogin:(id)sender
{
    NSString *sww_Num = [self fitSwwNum];
    [[HttpService sharedInstance] isExists:@{@"sww_number":sww_Num} completionBlock:^(id object) {
        _strBlock(sww_Num);
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    
 
    
}
    
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userNameField) {
        [_pwdField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -- 随机生成一个八位数
- (NSString *)randomNum{
    //自动生成8位随机密码
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    NSString *randomString = [NSString stringWithFormat:@"%.8f",random];
    NSString *randomSww_num = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    return randomSww_num;
}
#pragma mark -- 是否符合晒娃娃号需求
- (NSString *)fitSwwNum
{
    NSString *number = [self randomNum];                      //获取随机数
    int count = 0;
    for (int i = 0; i < 8; i++) {
        char num = [number characterAtIndex:i];
        if (num == '4') {
            count ++;
            if (count > 3) {
                [self fitSwwNum];
            }
            if (i == 7) {
                [self fitSwwNum];
            }
        }
    }
    return number;
}
@end
