//
//  TopicViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
typedef void (^DidSelectTopic)(NSString * topic);
@interface TopicViewController : CommonViewController<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *topicList;
}
@property (strong, nonatomic) IBOutlet UITableView *topicListTableView;
@property (strong, nonatomic) IBOutlet UITextField *topicValue;
@property (copy,nonatomic) DidSelectTopic didSelectTopic;
- (IBAction)finishAction:(id)sender;

@end
