//
//  AddFriendViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-10-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface AddFriendViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UITextField *remarkField;
@property (nonatomic,strong) NSString * friendID;
- (IBAction)submitAction:(id)sender;

@end
