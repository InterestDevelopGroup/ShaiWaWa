//
//  MessageViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "HMSegmentedControl.h"

@interface MessageViewController : CommonViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    HMSegmentedControl *segMentedControl;

}
@property (strong, nonatomic) IBOutlet UIView *tabSelectionBar;
@property (strong, nonatomic) IBOutlet UIScrollView *segScrollView;
@property (strong, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UITableView *msgTableView;
@property (strong, nonatomic) IBOutlet UIView *haveReadMsgView;
@property (weak, nonatomic) IBOutlet UITableView *haveReadMsgTableView;
@end
