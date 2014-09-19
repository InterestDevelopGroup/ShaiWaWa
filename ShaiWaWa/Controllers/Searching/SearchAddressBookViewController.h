//
//  SearchAddressBookViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface SearchAddressBookViewController : CommonViewController

@property (nonatomic,strong) NSString * type;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
- (IBAction)addrBookNext:(id)sender;
@end
