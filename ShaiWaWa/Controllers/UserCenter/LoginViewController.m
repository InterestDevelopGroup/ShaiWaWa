//
//  LoginViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "LoginViewController.h"
#import "ControlCenter.h"
#import "ChooseModeViewController.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "TheThirdPartyLoginView.h"
#import "HttpService.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "InputHelper.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
#pragma mark - Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _hoverRegisterLabel = nil;
    _phoneField = nil;
    _pwdField = nil;
}


#pragma mark - Private Methods
- (void)initUI
{
    self.title = NSLocalizedString(@"LoginVCTitle", nil);
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:_hoverRegisterLabel.text];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]} range:NSMakeRange(0, attrString.length)];
    _hoverRegisterLabel.attributedText = attrString;
    _hoverRegisterLabel.textColor = [UIColor lightGrayColor];
    TheThirdPartyLoginView *thirdLoginView = [[TheThirdPartyLoginView alloc] initWithFrame:CGRectMake(0, 0, 242, 116)];
    thirdLoginView.unbindBlock = ^(NSString * token,NSString * type){
        

        
    };
    thirdLoginView.bindBlock = ^(UserInfo * user){
        [self showChooseModeVC];
    };
    [_thirdSuperView addSubview:thirdLoginView];
    
    
}

- (IBAction)showRegisterVC:(id)sender
{
    [ControlCenter pushToRegisterVC];//zhengchang de push
//    [ControlCenter pushToFinishRegisterVC];
//    [ControlCenter pushToPostValidateVC];
}

- (IBAction)showMainVC:(id)sender
{
    [_phoneField resignFirstResponder];
    [_pwdField resignFirstResponder];
    NSString * phone = [InputHelper trim:_phoneField.text];
    NSString * pass = [InputHelper trim:_pwdField.text];
    
    if([phone length] == 0)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"手机不能为空", nil)];
        return ;
    }
    
    if(![InputHelper isPhone:phone])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"InvalidatePhone", nil)];
        return ;
    }
    
    if([InputHelper isEmpty:pass])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"PassCanNotEmpty", nil)];
        return ;
    }
    
    
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setStatus:NSLocalizedString(@"Logining", nil)];
    [[HttpService sharedInstance] userLogin:@{@"phone":phone,@"password":pass}completionBlock:^(id object){
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoginSuccess", nil)];
        _phoneField.text = nil;
        _pwdField.text = nil;
        [self showChooseModeVC];
    } failureBlock:^(NSError *error, NSString *responseString){
        [SVProgressHUD showErrorWithStatus:@"手机号或密码错误."];
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
    if (textField == _phoneField) {
        [_pwdField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}
    
    

@end
