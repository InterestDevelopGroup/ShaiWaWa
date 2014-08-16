//
//  AddHeightAndWeightViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface AddHeightAndWeightViewController : CommonViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *heightField;
@property (strong, nonatomic) IBOutlet UITextField *weightField;
@property (strong, nonatomic) NSString *addCurBabyId;
- (IBAction)timeSelected:(id)sender;

- (IBAction)add_OK:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@end
