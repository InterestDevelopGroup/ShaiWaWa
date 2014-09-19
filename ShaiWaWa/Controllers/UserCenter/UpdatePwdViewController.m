//
//  UpdatePwdViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UpdatePwdViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "HttpService.h"
#import "SVProgressHUD.h"

@interface UpdatePwdViewController ()

@end

@implementation UpdatePwdViewController

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

- (IBAction)update_OK:(id)sender
{
    [_olderPwdField resignFirstResponder];
    [_newsPwdField resignFirstResponder];
    [_repeatPwdField resignFirstResponder];
    if (_olderPwdField.text.length > 0 && _newsPwdField.text.length > 0 && _repeatPwdField.text.length > 0) {
        if ([_newsPwdField.text isEqualToString:_repeatPwdField.text]) {
            UserInfo *curUser = [[UserInfo alloc] init];
            curUser.phone = [[[UserDefault sharedInstance] userInfo] phone];
            curUser.username = [[[UserDefault sharedInstance] userInfo] username];
            NSString *orgin_pwd = [[[UserDefault sharedInstance] userInfo] password];
            curUser.password = _newsPwdField.text;
            curUser.uid = [[[UserDefault sharedInstance] userInfo] uid];
            curUser.sex = [[[UserDefault sharedInstance] userInfo] sex];
            curUser.sww_number = [[[UserDefault sharedInstance] userInfo] sww_number];
            
            if (![_olderPwdField.text isEqualToString:orgin_pwd]) {
                [SVProgressHUD showErrorWithStatus:@"原密码有误"];
                return;
            }
            [[HttpService sharedInstance] changePassword:@{@"user_id":curUser.uid,@"origin_password":orgin_pwd,@"password":curUser.password} completionBlock:^(id object) {
                [SVProgressHUD showSuccessWithStatus:@"更新成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } failureBlock:^(NSError *error, NSString *responseString) {
                [SVProgressHUD showErrorWithStatus:responseString];
            }];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"两次密码不一致"];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"文本框不允许为空"];
    }
    
    
}

#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"密码";
    [self setLeftCusBarItem:@"square_back" action:nil];
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _olderPwdField) {
        [_newsPwdField becomeFirstResponder];
        return NO;
    }
    if (textField == _newsPwdField) {
        [_repeatPwdField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
@end
