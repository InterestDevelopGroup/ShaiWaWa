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
- (IBAction)getCoreAgainEvent:(id)sender;
- (IBAction)showFinishRegisterVC:(id)sender;

@end
