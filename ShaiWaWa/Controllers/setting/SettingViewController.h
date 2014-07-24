//
//  SettingViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface SettingViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *sectionArr;
    NSMutableArray *setAllList;
    NSMutableArray *basicSetList, *autoShareSetList, *onlyUploadInWifiSetList, *otherSetList;
    NSDictionary *setList;
}
@property (strong, nonatomic) IBOutlet UITableView *setListTableView;
@property (strong, nonatomic) IBOutlet UIView *customFootView;
- (IBAction)quitCurAccountEvent:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *quitCurBtn;
@end
