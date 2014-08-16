//
//  SearchRSViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface SearchRSViewController : CommonViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *searchRSListTableView;
@property (strong, nonatomic) NSString *searchValue;
@property (strong, nonatomic) IBOutlet UITextField *searchRSField;
@property (strong, nonatomic) NSMutableArray *friendArray;
@end
