//
//  SettingViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface SettingViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSArray *sectionArr;
    NSMutableArray *setAllList;
    NSMutableArray *basicSetList, *autoShareSetList, *onlyUploadInWifiSetList, *otherSetList;
    NSDictionary *setList;
    
}
@property (strong, nonatomic) IBOutlet UITableView *setListTableView;
@property (strong, nonatomic) IBOutlet UIView *customFootView;
@property (weak, nonatomic) IBOutlet UIButton *quitCurBtn;
@property (strong, nonatomic) IBOutlet UIView *invitationView;

- (IBAction)quitCurAccountEvent:(id)sender;
- (IBAction)msgInvitation:(id)sender;
- (IBAction)wechatInvitation:(id)sender;

@end
