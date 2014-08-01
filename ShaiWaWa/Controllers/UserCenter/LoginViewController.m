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

@interface LoginViewController ()

@end

@implementation LoginViewController

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

- (void)dealloc
{
    _hoverRegisterLabel = nil;
    _phoneField = nil;
    _pwdField = nil;
}
    
#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"登陆";
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:_hoverRegisterLabel.text];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]} range:NSMakeRange(0, attrString.length)];
    _hoverRegisterLabel.attributedText = attrString;
    _hoverRegisterLabel.textColor = [UIColor lightGrayColor];
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    if (users != nil)
    {
        _phoneField.text = users.phone;
        _pwdField.text = users.password;
        [self showMainVC:nil];
    }
    
    
    TheThirdPartyLoginView *thirdLoginView = [[TheThirdPartyLoginView alloc] initWithFrame:CGRectMake(0, 0, 242, 116)];
    
    [thirdLoginView setXinlanBlock:^(void){
        NSLog(@"sina");
    }];
    [thirdLoginView setQqBlock:^(void){
        NSLog(@"qq");
    }];
    
    [_thirdSuperView addSubview:thirdLoginView];
    
    afHttp = [AFHttp shareInstanced];
    isRec = afHttp.isReachableViaWiFi;
    
}

- (IBAction)showRegisterVC:(id)sender
{
    [ControlCenter pushToRegisterVC];
}

- (IBAction)showMainVC:(id)sender
{
    [_phoneField resignFirstResponder];
    [_pwdField resignFirstResponder];
    if (_phoneField.text.length > 0) {
        
        [[HttpService sharedInstance] userLogin:@{@"phone":_phoneField.text,@"password":_pwdField.text}
                    completionBlock:^(id object){
                        
//                        ChooseModeViewController *chooseModeVC = [[ChooseModeViewController alloc] init];
//                        [self.navigationController pushViewController:chooseModeVC animated:YES];
//
//                        _phoneField.text = nil;
//                        _pwdField.text = nil;
                        [SVProgressHUD dismiss];
                        [SVProgressHUD showSuccessWithStatus:@"成功登陆"];
                        NSLog(@"跳转主页面");
                    } failureBlock:^(NSError *error, NSString *responseString){
                        [SVProgressHUD showErrorWithStatus:responseString];
        }];
    }
    else
    {
          [SVProgressHUD showErrorWithStatus:@"文本框不能为空哦"];
        
        
//        [[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"文本框不能为空"];
       
        DDLogInfo(@"文本框不能为空");
        
    }
    
}


//取消登陆
/*
 [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
 
 */

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
