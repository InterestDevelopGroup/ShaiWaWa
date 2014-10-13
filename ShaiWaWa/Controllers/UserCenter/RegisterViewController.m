//
//  RegisterViewController.m
//  ShaiWaWa
//  注册页面
//  Created by Carl on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "RegisterViewController.h"
#import "ControlCenter.h"
#import "TheThirdPartyLoginView.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "InputHelper.h"
#import "PostValidateViewController.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    self.title = NSLocalizedString(@"RegisterVCTitle", nil);
    [self.navigationItem setHidesBackButton:YES];
    myDelegate = [[UIApplication sharedApplication] delegate];
    /*
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:_hoverLoginLabel.text];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]} range:NSMakeRange(0, attrString.length)];
    _hoverLoginLabel.attributedText = attrString;
    _hoverLoginLabel.textColor = [UIColor lightGrayColor];
    */
    TheThirdPartyLoginView *thirdLoginView = [[TheThirdPartyLoginView alloc] initWithFrame:CGRectMake(0, 0, 242, 116)];
    
    
    [_thirdSuperView addSubview:thirdLoginView];
    
}

- (IBAction)showLoginVC:(id)sender
{
    [self popVIewController];
}
    
- (IBAction)showPostValidateVC:(id)sender
{
    myDelegate.postValidateType = @"reg";
    [_phoneField resignFirstResponder];
    NSString * phone = [InputHelper trim:_phoneField.text];
    if (phone.length == 0)
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"CanNotEmpty", nil)];
        return ;
    }
    
    if(![InputHelper isPhone:phone])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"InvalidatePhone", nil)];
        return ;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [[HttpService sharedInstance] sendValidateCode:@{@"phone":phone} completionBlock:^(id object) {
        [self showNextStepWithPhone:phone];
        _phoneField.text = nil;
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SendSuccess", nil)];
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        NSString * msg = responseString;
        if(error != nil)
        {
            msg = NSLocalizedString(@"SendError", nil);
        }
        
        [SVProgressHUD showErrorWithStatus:msg];
        
    }];
   
    
}


- (void)showNextStepWithPhone:(NSString *)phone
{
    PostValidateViewController * vc = [[PostValidateViewController alloc] initWithNibName:nil bundle:nil];
    vc.currentPhone = phone;
    [self push:vc];
    vc = nil;
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
