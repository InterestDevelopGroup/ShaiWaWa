//
//  ResetPwdNextStepViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface ResetPwdNextStepViewController : CommonViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *pwdField;
- (IBAction)disableSecure:(id)sender;
- (IBAction)FinishResetAndShowLoginVC:(id)sender;

@end
