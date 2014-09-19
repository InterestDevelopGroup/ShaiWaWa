//
//  SetPasswordStepOneViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-9-18.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface SetPasswordStepOneViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

- (IBAction)nextAction:(id)sender;

@end
