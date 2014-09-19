//
//  PostValidateViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "AppDelegate.h"

@interface PostValidateViewController : CommonViewController
{
    AppDelegate *myDelegate;
    int countBacki;
}
@property (nonatomic,strong) NSString * currentPhone;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *validateCoreTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCoreAgainButton;
@property (assign, nonatomic) BOOL isBinding;
//0 通讯录绑定， 1 手机绑定 , 2 设置密码
@property (nonatomic,strong) NSString * type;
- (IBAction)getCoreAgainEvent:(id)sender;
- (IBAction)showFinishRegisterVC:(id)sender;

@end
