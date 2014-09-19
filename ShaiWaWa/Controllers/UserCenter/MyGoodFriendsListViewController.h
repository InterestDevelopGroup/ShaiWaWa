//
//  MyGoodFriendsListViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface MyGoodFriendsListViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *friendsArr;
}
@property (strong, nonatomic) IBOutlet UITableView *goodFriendListTableView;
@property (weak, nonatomic) IBOutlet UITextField *keyworkField;

@end
