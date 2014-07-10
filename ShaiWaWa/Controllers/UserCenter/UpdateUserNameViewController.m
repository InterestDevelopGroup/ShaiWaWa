//
//  UpdateUserNameViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UpdateUserNameViewController.h"
#import "UIViewController+BarItemAdapt.h"

@interface UpdateUserNameViewController ()

@end

@implementation UpdateUserNameViewController
@synthesize userName;
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
    self.title = @"用户名";
    [self setLeftCusBarItem:@"square_back" action:nil];
    _userNameField.text = userName;
}

- (IBAction)update_OK:(id)sender {
}
@end
