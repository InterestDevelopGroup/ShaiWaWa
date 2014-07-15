//
//  SearchAddressBookViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SearchAddressBookViewController.h"
#import "UIViewController+BarItemAdapt.h"
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
    self.title = @"查找通讯录好友";
    [self setLeftCusBarItem:@"square_back" action:nil];
    myDelegate = [[UIApplication sharedApplication] delegate];
}
- (IBAction)addrBookNext:(id)sender
{
    PostValidateViewController *postValidate = [[PostValidateViewController alloc] init];
    myDelegate.postValidateType = @"addrBook";
    [self.navigationController pushViewController:postValidate animated:YES];
}
@end
