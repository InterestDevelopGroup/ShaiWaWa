//
//  SearchAddressListViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "AddrBookCell.h"

@interface SearchAddressListViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *sectionArr;
    NSArray *friendsAll;
    NSArray *waitToCardList, *mayYaoQiList;
    NSDictionary *freindsList;
    int numOfYaoQing;
    AddrBookCell * addrBookCell;
    BOOL isSelectedBtn;
}
@property (strong, nonatomic) IBOutlet UITableView *addrListTableView;


@end
