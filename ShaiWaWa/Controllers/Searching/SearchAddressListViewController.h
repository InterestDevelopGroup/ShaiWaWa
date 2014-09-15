//
//  SearchAddressListViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "AddrBookCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SearchAddressListViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *sectionArr;
    BOOL isSelectedBtn;
}
@property (strong, nonatomic) IBOutlet UITableView *addrListTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)searchAction:(id)sender;


@end
