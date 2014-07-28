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
        _phoneField.text = users.username;
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
    NSLog(@"%hhd",isRec);
    
}

- (IBAction)showRegisterVC:(id)sender
{
    [ControlCenter pushToRegisterVC];
}

- (IBAction)showMainVC:(id)sender
{
    if (_phoneField.text.length > 0) {
        if ([_phoneField.text isEqualToString:@"x"]) {
            if ([_pwdField.text isEqualToString:@"123"]) {
                ChooseModeViewController *chooseModeVC = [[ChooseModeViewController alloc] init];
                [self.navigationController pushViewController:chooseModeVC animated:YES];
                UserInfo *curUser = [[UserInfo alloc] init];
                curUser.username = _phoneField.text;
                curUser.password = _pwdField.text;
                
                [[UserDefault sharedInstance] setUserInfo:curUser];
                _phoneField.text = nil;
                _pwdField.text = nil;
                
            }
            else
            {
                DDLogInfo(@"密码错误");
            }
        }
        else
        {
            DDLogInfo(@"用户不存在");
        }
    }
    else
    {
        
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
