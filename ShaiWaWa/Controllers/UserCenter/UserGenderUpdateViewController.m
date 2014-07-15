//
//  UserGenderUpdateViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UserGenderUpdateViewController.h"
#import "UIViewController+BarItemAdapt.h"

@interface UserGenderUpdateViewController ()

@end

@implementation UserGenderUpdateViewController

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
    self.title = @"性别";
    [self setLeftCusBarItem:@"square_back" action:nil];
    isSecure = NO;
    isMan = YES;
    isWoman = NO;
    
}
- (IBAction)secureSelected:(id)sender
{
    isSecure = YES;
    isMan = NO;
    isWoman = NO;
    [_secureButton setImage:[UIImage imageNamed:@"main_dian.png"] forState:UIControlStateNormal];
    [_manButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
    [_womanButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
}

- (IBAction)manSelected:(id)sender
{
    isSecure = NO;
    isMan = YES;
    isWoman = NO;
    [_secureButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
    [_manButton setImage:[UIImage imageNamed:@"main_dian.png"] forState:UIControlStateNormal];
    [_womanButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
}

- (IBAction)womanSelected:(id)sender
{
    isSecure = NO;
    isMan = NO;
    isWoman = YES;
    [_secureButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
    [_manButton setImage:[UIImage imageNamed:@"main_dian-.png"] forState:UIControlStateNormal];
    [_womanButton setImage:[UIImage imageNamed:@"main_dian.png"] forState:UIControlStateNormal];
}

- (IBAction)update_ok:(id)sender {
}
@end
