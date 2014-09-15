//
//  SearchDynamicViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-11.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SearchDynamicViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "ChooseModeViewController.h"
#import "InputHelper.h"
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods
- (void)initUI
{
    self.title = NSLocalizedString(@"SearchRecordVCTitle", nil);
    [self setLeftCusBarItem:@"square_back" action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:NSLocalizedString(@"Finish", nil) forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 40, 30)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(finishDone) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)finishDone
{
    NSString * keyword = [InputHelper trim:_keywordTextField.text];
    if([InputHelper isEmpty:keyword])
    {
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"CanNotEmpty", nil)];
        return ;
    }
    
    if(self.searchBlock)
    {
        self.searchBlock(keyword);
    }
    
    [self popVIewController];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
