//
//  SearchAddressListViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SearchAddressListViewController.h"
#import "UIViewController+BarItemAdapt.h"

@interface SearchAddressListViewController ()

@end

@implementation SearchAddressListViewController

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
    self.title = @"查找微博好友";
    [self setLeftCusBarItem:@"square_back" action:nil];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:[NSString stringWithFormat:@"邀请(%i)",10] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 80, 30)];
//    [btn setImage:<#(UIImage *)#> forState:<#(UIControlState)#>];
//    [btn setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>];
    [btn addTarget:self action:@selector(YaoQing) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)YaoQing
{
    
}
@end
