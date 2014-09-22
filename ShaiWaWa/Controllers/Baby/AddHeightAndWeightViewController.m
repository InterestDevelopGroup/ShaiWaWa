//
//  AddHeightAndWeightViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AddHeightAndWeightViewController.h"
#import "UIViewController+BarItemAdapt.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "InputHelper.h"
@interface AddHeightAndWeightViewController ()

@end

@implementation AddHeightAndWeightViewController
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
    self.title = @"添加身高体重";
    [self setLeftCusBarItem:@"square_back" action:nil];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *morelocationString = [dateformatter stringFromDate:senddate];
    _datePicker.maximumDate = [NSDate date];
    _dateField.text = morelocationString;
    _heightField.inputAccessoryView = _toolbar;
    _weightField.inputAccessoryView = _toolbar;
    _dateField.inputAccessoryView = _toolbar;
    _dateField.inputView = _datePicker;
}


- (IBAction)add_OK:(id)sender
{
    NSString * height = [InputHelper trim:_heightField.text];
    NSString * weight = [InputHelper trim:_weightField.text];
    if([InputHelper isEmpty:height])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写身高"];
        return ;
    }
    
    if([InputHelper isEmpty:weight])
    {
        [SVProgressHUD showErrorWithStatus:@"请填写体重"];
        return ;
    }
    //根据宝宝信息判断他的体型
    [self judgeShapeWithSex:[_babyInfo.sex intValue] Age:_babyInfo.birthday Height:[height floatValue]Weight:[weight floatValue]];
    return;
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] addBabyGrowRecord:@{@"baby_id":_babyInfo.baby_id,@"height":height,@"weight":weight,@"uid":user.uid} completionBlock:^(id object) {
          [SVProgressHUD showSuccessWithStatus:@"添加成功."];
          _heightField.text = nil;
          _weightField.text = nil;
          [_heightField resignFirstResponder];
          [_weightField resignFirstResponder];
      } failureBlock:^(NSError *error, NSString *responseString) {
          NSString * msg = responseString;
          if (error) {
              msg = @"添加失败";
          }
          [SVProgressHUD showErrorWithStatus:msg];
      }];
}


- (IBAction)dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
    [self resignFirstResponder];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _heightField) {
        [_weightField becomeFirstResponder];
        return NO;
    }
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - 根据宝宝的数据判断它的体型
- (NSString *)judgeShapeWithSex:(int)sex Age:(NSString *)birthday Height:(CGFloat)height Weight:(CGFloat)weight
{
    //获取今天的日期
    NSDate *today = [[NSDate alloc] init];
    NSLog(@"birthday:%@",birthday);
    NSLog(@"today:%@",today);
    
    return nil;
}
@end
