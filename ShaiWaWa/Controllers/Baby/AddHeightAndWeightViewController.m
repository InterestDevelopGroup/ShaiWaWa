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
    int bodyType = [self judgeShapeWithSex:[_babyInfo.sex intValue] Age:_babyInfo.birthday Height:[height floatValue]Weight:[weight floatValue]];
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] addBabyGrowRecord:@{@"baby_id":_babyInfo.baby_id,@"height":height,@"weight":weight,@"uid":user.uid,@"body_type":[NSString stringWithFormat:@"%d",bodyType]} completionBlock:^(id object) {
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

#pragma mark - 根据宝宝的数据判断它的体型，宝宝性别（1：男，2：女）
- (int)judgeShapeWithSex:(int)sex Age:(NSString *)birthday Height:(CGFloat)height Weight:(CGFloat)weight
{
    //计算今天与宝宝出生日期相差的天数
    int deltaDay = [self calculateDeltaDay:birthday];
    //初始化身高体重数组
    NSArray *heightArray = nil;
    NSArray *weightArray = nil;
    if (sex == 1) {
        heightArray = [self loadArrayWithName:@"男孩身高"];
        weightArray = [self loadArrayWithName:@"男孩体重"];
    }else
    {
        heightArray = [self loadArrayWithName:@"女孩身高"];
        weightArray = [self loadArrayWithName:@"女孩体重"];
    }
    if (deltaDay > heightArray.count || deltaDay > weightArray.count) {
        return 0;
    }
    
    /*
     o “完美体型”:宝宝的身高或体重数值介于“SD1”及“SD1Neg”之间 
     o “基本正常”:宝宝的身高或体重数值介于“SD1”及“SD2”之间或“SD1Neg”及“SD2Neg”之间
     o “偏胖”:宝宝的体重数值大于“SD2”
     o “偏瘦”:宝宝的体重数值小于“SD2Neg” 
     o “偏高”:宝宝的身高数值大于“SD2”
     o “偏矮”:宝宝的身高数值小于“SD2Neg”
     
      0       1        2       3      4      5   6   7   8   9
     Day	SD4neg	SD3neg	SD2neg	SD1neg	SD0	SD1	SD2	SD3	SD4
     
     typedef enum {
     kBabyTypeUnknow = 0,
     kBabyTypeNormal = 1,
     kBabyTypePerfect = 2,
     kBabyTypeLean = 3,
     kBabyTypeFat = 4,
     kBabyTypeTall = 5,
     kBabyTypeShort = 6
     } babyType;
     
     */
    
    //取出某天宝宝的数据对照标准
    NSArray *standardHeight = heightArray[deltaDay];
    NSArray *standardWeight = weightArray[deltaDay];
    
    if ((weight >= [standardWeight[4] floatValue] && weight <= [standardWeight[6] floatValue ]) || (height >= [standardHeight[4] floatValue] && height <= [standardHeight[6] floatValue]) ) {
        return 2;
    }
    
    if ((weight >= [standardWeight[3] floatValue] && weight <= [standardWeight[4] floatValue ])
        || (weight >= [standardWeight[6] floatValue] && weight <= [standardWeight[7] floatValue ])
        || (height >= [standardHeight[3] floatValue] && height <= [standardHeight[4] floatValue])
        || (height >= [standardHeight[6] floatValue] && height <= [standardHeight[7] floatValue])
        ) {
        return 1;
    }
    
    if (weight > [standardWeight[7] floatValue]) {
        return 4;
    }
    
    if (weight < [standardWeight[3] floatValue]) {
        return 3;
    }
    
    if (height > [standardHeight[7] floatValue]) {
        return 5;
    }
    
    if (height < [standardHeight[3] floatValue]) {
        return 6;
    }
    
    return 0;
}

#pragma mark - 计算今天与宝宝出生日期相差的天数
- (int)calculateDeltaDay:(NSString *)birth
{
    //将生日转换成NSDate对象
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YY-MM-dd";
    NSDate *birthday = [fmt dateFromString:birth];
    //获取今天的日期
    NSDate *today = [NSDate date];
    return (int)([today timeIntervalSinceDate:birthday] / (60 * 60 * 24));
}

- (NSArray *)loadArrayWithName:(NSString *)fileName
{
    NSString *path = [[NSBundle mainBundle] pathForResource:
                            fileName ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

@end
