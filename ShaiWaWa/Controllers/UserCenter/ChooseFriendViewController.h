//
//  ChooseFriendViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
typedef void (^FinishSelectedBloock)(NSArray * friends);
@interface ChooseFriendViewController : CommonViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *friendSelectListTableView;
@property (copy, nonatomic) FinishSelectedBloock finishSelectedBlock;
@end
