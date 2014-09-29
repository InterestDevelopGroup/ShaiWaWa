//
//  BabyListViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface BabyListViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSArray *sectionArr;
    NSMutableArray *myBabyList, *friendsBabyList;
}
@property (strong, nonatomic) IBOutlet UITableView *babyListTableView;

@end
