//
//  BindUserViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-9-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface BindUserViewController : CommonViewController
@property (nonatomic,strong) NSString * token;
@property (nonatomic,strong) NSString * type;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
- (IBAction)bindAction:(id)sender;

@end
