//
//  FinishRegisterViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "FinishRegisterViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "ControlCenter.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "InputHelper.h"
@interface FinishRegisterViewController ()

@end

@implementation FinishRegisterViewController
@synthesize userNameField,pwdField;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
    
#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"完成注册";
    [self setLeftCusBarItem:@"square_back" action:nil];

    
}
- (IBAction)disableSecure:(id)sender
{
    [pwdField setSecureTextEntry:NO];
}
    
- (IBAction)finishRegisterAndLogin:(id)sender
{
    
    NSString * username = [InputHelper trim:userNameField.text];
    NSString * pass = [InputHelper trim:pwdField.text];
    
    if([InputHelper isEmpty:username])
    {
        [SVProgressHUD showErrorWithStatus:@"NameCanNotEmpty"];
        return ;
    }
    
    if([InputHelper isEmpty:pass])
    {
        [SVProgressHUD showErrorWithStatus:@"PassCanNotEmpty"];
        return ;
    }
    
    NSString *sww_Num = [self fitSwwNum];
    [[HttpService sharedInstance] isExists:@{@"sww_number":sww_Num} completionBlock:^(id object) {
        [self registerWithNum:sww_Num];
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        NSString * msg = NSLocalizedString(@"RegisterError", nil);
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
}

- (void)registerWithNum:(NSString *)sww_Num
{
    NSString * username = [InputHelper trim:userNameField.text];
    NSString * pass = [InputHelper trim:pwdField.text];
    [[HttpService sharedInstance] userRegister:@{@"username":username,@"password":pass,@"phone":_currentPhone,@"sww_number":sww_Num,@"validate_code":_validateCode} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"RegisterSuccess", nil)];
        [self popToRoot];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = NSLocalizedString(@"RegisterError", nil);
        if(error == nil)
            msg = responseString;
        [SVProgressHUD showErrorWithStatus:msg];
    }];

}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == userNameField) {
        [pwdField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}


#pragma mark -- 随机生成一个八位数
- (NSString *)randomNum
{
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
