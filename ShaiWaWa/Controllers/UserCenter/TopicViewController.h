//
//  TopicViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface TopicViewController : CommonViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *topicList;
}
@property (strong, nonatomic) IBOutlet UITableView *topicListTableView;
@property (strong, nonatomic) IBOutlet UITextField *topicValue;

@end
