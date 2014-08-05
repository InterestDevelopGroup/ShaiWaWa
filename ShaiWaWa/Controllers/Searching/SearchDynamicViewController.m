//
//  SearchDynamicViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-11.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SearchDynamicViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "HttpService.h"
#import "SVProgressHUD.h"

@interface SearchDynamicViewController ()

@end

@implementation SearchDynamicViewController

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
    self.title = @"搜索动态";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 40, 30)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(finishDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)finishDone
{
    [[HttpService sharedInstance] searchRecord:@{@"keyword":_keywordTextField.text, @"offset":@"1", @"pagesize":@"10" } completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"已更新"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
