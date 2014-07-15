//
//  UpdateUserNameViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface UpdateUserNameViewController : CommonViewController
@property (strong, nonatomic) IBOutlet UITextField *userNameField;
- (IBAction)update_OK:(id)sender;

@property (strong, nonatomic) NSString *userName;
@end
