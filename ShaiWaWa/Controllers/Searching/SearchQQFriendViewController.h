//
//  SearchQQFriendViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "QQCell.h"

@interface SearchQQFriendViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *sectionArr;
    NSArray *friendsAll;
    NSDictionary *freindsList;
    int numOfYaoQing;
    QQCell *qqCell;
    
}
@property (strong, nonatomic) IBOutlet UITableView *qqListTableView;


@end
