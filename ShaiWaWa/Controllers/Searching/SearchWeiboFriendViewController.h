//
//  SearchWeiboFriendViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "WeiBoCell.h"
@interface SearchWeiboFriendViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *sectionArr;
    NSArray *friendsAll;
    NSDictionary *freindsList;


}
@property (strong, nonatomic) IBOutlet UITableView *weiBoListTableView;


@end
