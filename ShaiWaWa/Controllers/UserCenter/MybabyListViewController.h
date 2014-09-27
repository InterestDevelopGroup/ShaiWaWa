//
//  MybabyViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "BabyInfo.h"
#import "UserInfo.h"
typedef void (^DidSelectBaby)(BabyInfo * babyInfo);
@interface MybabyListViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *babyListTableView;
@property (nonatomic,copy) DidSelectBaby didSelectBaby;
@property (nonatomic,strong) UserInfo * user;
@end
