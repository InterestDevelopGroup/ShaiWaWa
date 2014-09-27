//
//  HisFriendsViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-9-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "UserInfo.h"
#import "Friend.h"
@interface HisFriendsViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *friendsTableView;
@property (nonatomic,strong) UserInfo * user;
@end
