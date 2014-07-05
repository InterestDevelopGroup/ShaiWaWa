//
//  PostValidateViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PostValidateViewController.h"
#import "ControlCenter.h"

@interface PostValidateViewController ()

@end

@implementation PostValidateViewController

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
    self.title = @"提交验证码";
    [self setLeftCustomBarItem:@"square_back" action:nil imageEdgeInsets:UIEdgeInsetsMake(0, -70, 0, 0)];
    
}
    
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)showFinishRegisterVC:(id)sender
{
    [ControlCenter pushToFinishRegisterVC];
}
@end
