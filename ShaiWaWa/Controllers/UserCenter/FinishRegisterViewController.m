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
#import "ChooseModeViewController.h"
#import "SSCheckBoxView.h"
@interface FinishRegisterViewController ()/*<UITextFieldDelegate>*/

@end

@implementation FinishRegisterViewController
@synthesize userNameField,pwdField;
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
    
    SSCheckBoxView * checkButton = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(26, 120, 110, 20) style:kSSCheckBoxViewStyleGlossy checked:YES];
    [checkButton setText:@"显示密码"];
    [checkButton setStateChangedTarget:self selector:@selector(disableSecure:)];
    [self.view addSubview:checkButton];
    [pwdField setSecureTextEntry:YES];
    
    
}


- (IBAction)disableSecure:(SSCheckBoxView *)sender
{
    [pwdField setSecureTextEntry:sender.checked];
}
    
- (IBAction)finishRegisterAndLogin:(id)sender
{
    
    NSString * username = [InputHelper trim:userNameField.text];
    NSString * pass = [self checkPWD:pwdField.text];
    if (pass == nil) return;
//    NSString * pass = [InputHelper trim:pwdField.text];
    
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

#pragma mark - 判断用户密码的合理性
- (NSString *)checkPWD:(NSString *)pwd
{
    //判断密码长度
    if (pwd.length< 6 ||pwd.length > 10) {
        [self showAlertViewWithMessage:@"您的密码长度不正确，请重新输入"];
        pwdField.text = @"";
        return nil;
    }
    //判断密码字符的合理性
//    if (condition) {
//        statements
//    }
#warning 暂时不处理，应该判断字符的合法性
    return [InputHelper trim:pwd];
}

- (void)registerWithNum:(NSString *)sww_Num
{
    NSString * username = [InputHelper trim:userNameField.text];
    NSString * pass = [InputHelper trim:pwdField.text];
    [[HttpService sharedInstance] userRegister:@{@"username":username,@"password":pass,@"phone":_currentPhone,@"sww_number":sww_Num,@"validate_code":_validateCode} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"RegisterSuccess", nil)];
//        [self popToRoot];
        //注册成功后登陆
        [self loginWith:_currentPhone pwd:pass];
//        [self showChooseModeVC];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = NSLocalizedString(@"RegisterError", nil);
        if(error == nil)
            msg = responseString;
        [SVProgressHUD showErrorWithStatus:msg];
    }];

}

#pragma mark - 注册成功后登陆
- (void)loginWith:(NSString *)phone pwd:(NSString *)pass
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setStatus:NSLocalizedString(@"Logining", nil)];
    [[HttpService sharedInstance] userLogin:@{@"phone":phone,@"password":pass}completionBlock:^(id object){
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoginSuccess", nil)];
        userNameField.text = nil;
        pwdField.text = nil;
        [self showChooseModeVC];
    } failureBlock:^(NSError *error, NSString *responseString){
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
}

- (void)showChooseModeVC
{
    ChooseModeViewController *chooseModeVC = [[ChooseModeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:chooseModeVC animated:YES];
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
