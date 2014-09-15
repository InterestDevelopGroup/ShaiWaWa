//
//  AddHeightAndWeightViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "BabyInfo.h"
@interface AddHeightAndWeightViewController : CommonViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *heightField;
@property (strong, nonatomic) IBOutlet UITextField *weightField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (strong, nonatomic) BabyInfo * babyInfo;

- (IBAction)add_OK:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;


@end
