//
//  SearchGoodFriendsViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface SearchGoodFriendsViewController : CommonViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *typeOfFriendsArry, *typeIconArry;
}
@property (strong, nonatomic) IBOutlet UITableView *typeOfFriendsTableView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)startSearch:(id)sender;

@end
