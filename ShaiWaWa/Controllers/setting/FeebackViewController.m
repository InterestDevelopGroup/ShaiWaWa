//
//  FeebackViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "FeebackViewController.h"
#import "UIViewController+BarItemAdapt.h"

#import "HttpService.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "SVProgressHUD.h"

@interface FeebackViewController ()
{
    UserInfo * user;
}
@end

@implementation FeebackViewController

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
    self.title = @"意见反馈";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"发送" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 10, 40, 30)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(sendFeeBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    user = [[UserDefault sharedInstance] userInfo];
    [self copyOfWeb];
}
- (void)sendFeeBack
{
    [[HttpService sharedInstance] feedBack:@{@"uid":user.uid,@"content":_feedBackContentTextView.text} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"感谢您的反馈"];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    [self resignKeyboard];
    _feedBackContentTextView.text = nil;
}

- (void)copyOfWeb
{
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    
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
    
    [_feedBackContentTextView setInputAccessoryView:topView];
    //    topView.hidden = YES;
}


//隐藏键盘
-(void)resignKeyboard
{
    [_feedBackContentTextView resignFirstResponder];
}
@end
