//
//  DynamicDetailViewController.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-17.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface DynamicDetailViewController : CommonViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITableView *pinLunListTableView;
@end
