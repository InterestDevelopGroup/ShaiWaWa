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
    
}
- (IBAction)disableSecure:(id)sender
{
    [_pwdField setSecureTextEntry:NO];
}
    
- (IBAction)finishRegisterAndLogin:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
@end
