//
//  PostValidateViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PostValidateViewController.h"
#import "ControlCenter.h"
#import "UIViewController+BarItemAdapt.h"
#import "SearchAddressListViewController.h"

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
    [self setLeftCusBarItem:@"square_back" action:nil];
    myDelegate = [[UIApplication sharedApplication] delegate];
    
}
    
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)showFinishRegisterVC:(id)sender
{
    if ([myDelegate.postValidateType isEqualToString:@"reg"]) {
         [ControlCenter pushToFinishRegisterVC];
    }
    else if ([myDelegate.postValidateType isEqualToString:@"addrBook"])
    {
        SearchAddressListViewController *addressListVC = [[SearchAddressListViewController alloc] init];
        [self.navigationController pushViewController:addressListVC animated:YES];
    }
    else
    {
    
    }
   
}
@end
