//
//  RemarksViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface RemarksViewController : CommonViewController<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *remarksField;
@property (strong, nonatomic) IBOutlet UITextView *remarksTextField;
@property (strong, nonatomic) NSString *babyID;
- (IBAction)btn_OK:(id)sender;

@end
