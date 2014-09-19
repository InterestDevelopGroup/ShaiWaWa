//
//  SearchAddressBookViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SearchAddressBookViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "PostValidateViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "ControlCenter.h"
#import "InputHelper.h"
#import "PostValidateViewController.h"
@interface SearchAddressBookViewController ()

@end

@implementation SearchAddressBookViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Methods
- (void)initUI
{
    if([_type isEqualToString:@"1"])
    {
        self.title = @"绑定手机";
    }
    else
    {
        self.title = @"查找通讯录好友";
    }
    [self setLeftCusBarItem:@"square_back" action:nil];
}

- (IBAction)addrBookNext:(id)sender
{

    [_phoneField resignFirstResponder];
    
    NSString * phone = [InputHelper trim:_phoneField.text];
    
    if([InputHelper isEmpty:phone])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写手机号码."];
        return ;
    }
    
    if(![InputHelper isPhone:phone])
    {
        [SVProgressHUD showErrorWithStatus:@"手机号码无效."];
        return ;
    }

    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] sendValidateCode:@{@"phone":phone} completionBlock:^(id object) {
        
        [SVProgressHUD dismiss];
        _phoneField.text = nil;
        
        PostValidateViewController * vc = [[PostValidateViewController alloc] initWithNibName:nil bundle:nil];
        vc.currentPhone = phone;
        vc.isBinding = YES;
        vc.type = _type;
        [self push:vc];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"发送失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
   
}
@end
