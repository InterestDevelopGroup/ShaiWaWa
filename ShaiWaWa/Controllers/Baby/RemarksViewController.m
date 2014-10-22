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
#import "UITextView+Placeholder.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "BabyRemark.h"

@interface RemarksViewController ()<UITextViewDelegate>

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

#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"备注信息";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_remarksTextField setPlaceholder:@" 描述"];
    _remarksTextField.delegate = self;
//    [self getBabyRemarkInfo];
    _remarksField.text = _babyRemark.alias;
    _remarksTextField.text = _babyRemark.remark;
    if (_remarksTextField == nil || [_remarksTextField.text isEqualToString:@""] || [_remarksTextField.text isEqualToString:@"关于宝宝的描述" ]){
        [_remarksTextField setPlaceholder:@"关于宝宝的描述"];
    }
    _remarksTextField.delegate =self;
}

//- (void)getBabyRemarkInfo
//{
//    UserInfo *users = [[UserDefault sharedInstance] userInfo];
//    
//    [[HttpService sharedInstance] getBabyRemark:@{@"uid":users.uid,@"baby_id":_babyInfo.baby_id} completionBlock:^(id object) {
//        BabyRemark *remark = (BabyRemark *)object;
//        
//        _remarksField.text = remark==nil?@"":remark.alias;     //备注名称
//        _remarksTextField.text = remark==nil?@"":remark.remark; //备注详情
//    } failureBlock:^(NSError *error, NSString *responseString) {
//        [SVProgressHUD showErrorWithStatus:responseString];
//    }];
//}

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
    
    //用户没有修改内容
    if ([_remarksField.text isEqualToString:_babyRemark.alias] && [_remarksTextField.text isEqualToString:_babyRemark.remark]) {
        _babyHomeVC.remark = _babyRemark;
        [self popVIewController];
    }
    
    //判断一下这个宝宝是否有备注信息
    if (_babyRemark)
    {
        if (_remarksField.text.length <1)
        {
            //如果客户什么也没写，表示删除备注
            [[HttpService sharedInstance] deleteBabyRemark:@{@"uid":users.uid,@"baby_id":_babyInfo.baby_id} completionBlock:^(id object) {
                _babyHomeVC.isFromRemarkController = YES;
                [self popVIewController];
                _remarksField.text = nil;
                _remarksTextField.text = nil;
                
            } failureBlock:^(NSError *error, NSString *responseString) {
                [SVProgressHUD showErrorWithStatus:responseString];
            }];
        }
        else
        {
            NSString *alias = _remarksField.text;
            NSString *remark = _remarksTextField.text.length?_remarksTextField.text:@"";
            [[HttpService sharedInstance] updateBabyRemark:@{@"uid":users.uid,@"baby_id":_babyInfo.baby_id,@"alias":alias, @"remark":remark} completionBlock:^(id object) {
                _remarksField.text = nil;
                _remarksTextField.text = nil;
                _babyHomeVC.isFromRemarkController = YES;
                [self popVIewController];
            } failureBlock:^(NSError *error, NSString *responseString) {
                [SVProgressHUD showErrorWithStatus:responseString];
            }];
        }
        
    }
    else
    {
        if (_remarksField.text.length <1 && _remarksTextField.text.length < 1)
        {
            return;
        }
        NSString *alias = _remarksField.text;
        NSString *remark = _remarksTextField.text.length?_remarksTextField.text:@"";
        [[HttpService sharedInstance] addBabyRemark:@{@"uid":users.uid,@"baby_id":_babyInfo.baby_id,@"alias":alias, @"remark":remark} completionBlock:^(id object) {
            [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
            _remarksField.text = nil;
            _remarksTextField.text = nil;
            _babyHomeVC.isFromRemarkController = YES;
            [self popVIewController];
        } failureBlock:^(NSError *error, NSString *responseString) {
            [SVProgressHUD showErrorWithStatus:responseString];
        }];

    }

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

#pragma mark - 把textView的done键点击退出键盘
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
