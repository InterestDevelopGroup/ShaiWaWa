//
//  UserInfoPageViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface UserInfoPageViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *key;
}
@property (strong, nonatomic) IBOutlet UITableView *userInfoTableView;
@end
