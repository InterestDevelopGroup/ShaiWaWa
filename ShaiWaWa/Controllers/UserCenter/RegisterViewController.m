//
//  RegisterViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "RegisterViewController.h"
#import "ControlCenter.h"

#import "TheThirdPartyLoginView.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    self.title = @"注册";
    [self.navigationItem setHidesBackButton:YES];
    myDelegate = [[UIApplication sharedApplication] delegate];
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:_hoverLoginLabel.text];
    [attrString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle]} range:NSMakeRange(0, attrString.length)];
    _hoverLoginLabel.attributedText = attrString;
    _hoverLoginLabel.textColor = [UIColor lightGrayColor];
    
    TheThirdPartyLoginView *thirdLoginView = [[TheThirdPartyLoginView alloc] initWithFrame:CGRectMake(0, 0, 242, 116)];
    
    [thirdLoginView setXinlanBlock:^(void){
        NSLog(@"sina");
    }];
    [thirdLoginView setQqBlock:^(void){
       NSLog(@"qq");
    }];
    
    [_thirdSuperView addSubview:thirdLoginView];
    
}

- (IBAction)showLoginVC:(id)sender
{
    [self popVIewController];
}
    
- (IBAction)showPostValidateVC:(id)sender
{
    myDelegate.postValidateType = @"reg";
    
    [[HttpService sharedInstance] sendValidateCode:@{@"phone":_phoneField.text} completionBlock:^(id object) {
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    [ControlCenter pushToPostValidateVC];
}
    
    
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
