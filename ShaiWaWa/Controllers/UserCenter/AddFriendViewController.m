//
//  AddFriendViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-10-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AddFriendViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "SVProgressHUD.h"
#import "HttpService.h"
#import "UserInfo.h"
#import "UserDefault.h"
@interface AddFriendViewController ()

@end

@implementation AddFriendViewController

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
    self.title = @"添加好友";
    [self setLeftCusBarItem:@"square_back" action:nil];
}

- (IBAction)submitAction:(id)sender
{
    NSString * remark = _remarkField.text;
    
    if([remark length] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"备注不能为空."];
        return;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    UserInfo * userInfo = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] applyFriend:@{@"uid":userInfo.uid,@"friend_id":_friendID,@"remark":remark} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"已提交申请"];
        [self popVIewController];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"申请好友失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
        
    }];
    
}
@end
