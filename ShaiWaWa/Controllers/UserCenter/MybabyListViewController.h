//
//  MybabyViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "BabyInfo.h"
typedef void (^DidSelectBaby)(BabyInfo * babyInfo);
@interface MybabyListViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *babyListTableView;
@property (nonatomic,copy) DidSelectBaby didSelectBaby;
@end
