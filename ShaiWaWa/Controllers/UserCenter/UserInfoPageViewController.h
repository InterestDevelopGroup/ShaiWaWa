//
//  UserInfoPageViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//



#import "CommonViewController.h"
#import "UserInfo.h"
#import "UpdateUserNameViewController.h"

@interface UserInfoPageViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *key;
    NSMutableArray *keyOfvalue;
    UserInfo *users;
    UpdateUserNameViewController *updateUserVC;
    
    NSString *userNameVal;
    NSString *sexVal;
    NSString *pwdVal;
}
@property (strong, nonatomic) IBOutlet UITableView *userInfoTableView;
@end
