//
//  SearchWeiboFriendViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "WeiBoCell.h"
@interface SearchWeiboFriendViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *sectionArr;
    NSArray *friendsAll;
    NSDictionary *freindsList;
    int numOfYaoQing;
    WeiBoCell *weiBoCell;

}
@property (strong, nonatomic) IBOutlet UITableView *weiBoListTableView;


@end
