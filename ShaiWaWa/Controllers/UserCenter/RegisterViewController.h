//
//  RegisterViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface RegisterViewController : CommonViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UILabel *hoverLoginLabel;
- (IBAction)showLoginVC:(id)sender;

- (IBAction)showPostValidateVC:(id)sender;
@end
