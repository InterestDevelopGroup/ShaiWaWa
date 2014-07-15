//
//  UpdatePwdViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UpdatePwdViewController.h"
#import "UIViewController+BarItemAdapt.h"
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
