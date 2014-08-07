//
//  PostValidateViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "AppDelegate.h"

@interface PostValidateViewController : CommonViewController
{
    AppDelegate *myDelegate;
    int countBacki;
    NSTimer *timer;
}
- (IBAction)showFinishRegisterVC:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;

@property (weak, nonatomic) IBOutlet UITextField *validateCoreTextField;
@property (weak, nonatomic) IBOutlet UIButton *getCoreAgainButton;
- (IBAction)getCoreAgainEvent:(id)sender;

@end
