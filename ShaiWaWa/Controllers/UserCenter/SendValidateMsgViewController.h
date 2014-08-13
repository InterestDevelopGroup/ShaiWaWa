//
//  SendValidateMsgViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface SendValidateMsgViewController : CommonViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *remarkSendField;
@property (nonatomic, strong) NSString *unfamiliarId;
@end
