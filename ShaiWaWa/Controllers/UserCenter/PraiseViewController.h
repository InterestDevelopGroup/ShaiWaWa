//
//  PraiseViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "BabyRecord.h"
@interface PraiseViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *praisePersonArr;
}
@property (strong, nonatomic) IBOutlet UITableView *praisePersonListTableView;
@property (nonatomic,strong) BabyRecord * record;
@end
