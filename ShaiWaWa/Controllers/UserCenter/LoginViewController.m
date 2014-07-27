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

#import <ShareSDK/ShareSDK.h>


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

- (IBAction)sinaLoginEvent:(id)sender
{
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil
                result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
                {
                    if (result)
                    {
                        
                        NSLog(@"哈哈哈Sina!");
//                        PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
//                        [query whereKey:@"uid" equalTo:[userInfo uid]];
//                        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//                        {
//                            if ([objects count] == 0)
//                            {
//                                 PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
//                                 [newUser setObject:[userInfo uid] forKey:@"uid"];
//                                 [newUser setObject:[userInfo nickname] forKey:@"name"];
//                                 [newUser setObject:[userInfo icon] forKey:@"icon"];
//                                 [newUser saveInBackground];
//                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//                                 [alertView show];
//                                 [alertView release];
//                            }
//                            else
//                            {
//                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//                                 [alertView show];
//                                 [alertView release];
//                            }
//                        }];
                     }
//            MainViewController *mainVC = [[[MainViewController alloc] init] autorelease];
//            [self.navigationController pushViewController:mainVC animated:YES];
             }];
}

- (IBAction)qqLoginEvent:(id)sender
{
    
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         if (result)
         {
             
             NSLog(@"哈哈哈QQ!");
             //                        PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
             //                        [query whereKey:@"uid" equalTo:[userInfo uid]];
             //                        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
             //                        {
             //                            if ([objects count] == 0)
             //                            {
             //                                 PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
             //                                 [newUser setObject:[userInfo uid] forKey:@"uid"];
             //                                 [newUser setObject:[userInfo nickname] forKey:@"name"];
             //                                 [newUser setObject:[userInfo icon] forKey:@"icon"];
             //                                 [newUser saveInBackground];
             //                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
             //                                 [alertView show];
             //                                 [alertView release];
             //                            }
             //                            else
             //                            {
             //                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
             //                                 [alertView show];
             //                                 [alertView release];
             //                            }
             //                        }];
         }
         //            MainViewController *mainVC = [[[MainViewController alloc] init] autorelease];
         //            [self.navigationController pushViewController:mainVC animated:YES];
     }];
    
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
