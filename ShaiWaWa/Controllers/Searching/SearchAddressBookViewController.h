//
//  SearchAddressBookViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "AppDelegate.h"

@interface SearchAddressBookViewController : CommonViewController
{
    AppDelegate *myDelegate;
}
- (IBAction)addrBookNext:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@end
