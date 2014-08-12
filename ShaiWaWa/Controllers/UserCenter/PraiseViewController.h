//
//  PraiseViewController.h
//  ShaiWaWa
//
//  Created by x on 14-7-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface PraiseViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *praisePersonArr;
}
@property (strong, nonatomic) IBOutlet UITableView *praisePersonListTableView;
@property (strong, nonatomic) NSString *priaseRid;
@end
