//
//  BabyListViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface BabyListViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *sectionArr;
    NSMutableArray *myBabyList, *friendsBabyList;
}
@property (strong, nonatomic) IBOutlet UITableView *babyListTableView;
- (IBAction)searchBaby:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
