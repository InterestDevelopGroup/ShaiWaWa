//
//  FinishRegisterViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface FinishRegisterViewController : CommonViewController
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *pwdField;
- (IBAction)disableSecure:(id)sender;
- (IBAction)finishRegisterAndLogin:(id)sender;

@end
