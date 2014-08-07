//
//  FinishRegisterViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "AppDelegate.h"

typedef void(^StrBlock)(NSString *);

@interface FinishRegisterViewController : CommonViewController
{
    AppDelegate *mydelegate;
}
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
@property (strong, nonatomic) IBOutlet UITextField *pwdField;
@property (strong, nonatomic) StrBlock strBlock;
- (IBAction)disableSecure:(id)sender;
- (IBAction)finishRegisterAndLogin:(id)sender;

@end
