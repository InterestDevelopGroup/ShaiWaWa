//
//  LoginViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "AFHttp.h"

@interface LoginViewController : CommonViewController<UITextFieldDelegate>
{
    AFHttp *afHttp;
    BOOL isRec;
}
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UITextField *pwdField;
@property (strong, nonatomic) IBOutlet UILabel *hoverRegisterLabel;
- (IBAction)showRegisterVC:(id)sender;
- (IBAction)showMainVC:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *thirdSuperView;

@end
