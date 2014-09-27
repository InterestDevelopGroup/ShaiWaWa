//
//  RemarksViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "RemarksViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "UITextView+Placeholder.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"

@interface RemarksViewController ()

@end

@implementation RemarksViewController
@synthesize babyID;
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
    self.title = @"备注信息";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_remarksTextField setPlaceholder:@" 描述"];
    _remarksTextField.delegate = self;
    [self copyOfWeb];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _remarksField) {
        [_remarksTextField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)btn_OK:(id)sender
{
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    //alias:标题
    [[HttpService sharedInstance] addBabyRemark:@{@"uid":users.uid,@"baby_id":_babyInfo.baby_id,@"alias":_remarksField.text, @"remark":_remarksTextField.text} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
        _remarksField.text = nil;
        _remarksTextField.text = nil;
        [self popVIewController];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
}


- (void)copyOfWeb
{
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 49)];
    

    
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UITextField *temp_txt = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 120, 30)];
    temp_txt.hidden = YES;
    UIBarButtonItem * txtItem =[[UIBarButtonItem  alloc] initWithCustomView:temp_txt];
    
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:txtItem,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    //    [textView setInputView:topView];
    
    [_remarksTextField setInputAccessoryView:topView];
    //    topView.hidden = YES;
}


//隐藏键盘
-(void)resignKeyboard
{
    [_remarksTextField resignFirstResponder];
}

@end
