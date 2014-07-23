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
#import "User.h"

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
//    if ([UserDefault sharedInstance].user != nil)
//    {
//        _phoneField.text = [UserDefault sharedInstance].user.username;
//        _pwdField.text = [UserDefault sharedInstance].user.password;
//        [self showMainVC:nil];
//    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"tips" message:[UserDefault sharedInstance].user.username delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alert show];
    
    
    
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
                User *curUser = [[User alloc] init];
                curUser.username = _phoneField.text;
                curUser.password = _pwdField.text;
                [User saveToLocal:curUser];
                [UserDefault sharedInstance].user = [User userFromLocal];
                
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
