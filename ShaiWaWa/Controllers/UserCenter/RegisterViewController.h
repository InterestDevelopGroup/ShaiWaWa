//
//  RegisterViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "AppDelegate.h"

@interface RegisterViewController : CommonViewController
{
    AppDelegate *myDelegate;
}
@property (strong, nonatomic) IBOutlet UITextField *phoneField;
@property (strong, nonatomic) IBOutlet UILabel *hoverLoginLabel;
- (IBAction)showLoginVC:(id)sender;

- (IBAction)showPostValidateVC:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *thirdSuperView;
@end
