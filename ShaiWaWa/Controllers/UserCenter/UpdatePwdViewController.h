//
//  UpdatePwdViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface UpdatePwdViewController : CommonViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *olderPwdField;
@property (strong, nonatomic) IBOutlet UITextField *newsPwdField;
@property (strong, nonatomic) IBOutlet UITextField *repeatPwdField;
- (IBAction)update_OK:(id)sender;

@end
