//
//  TopicListOfDynamic.h
//  ShaiWaWa
//
//  Created by Carlon 14-7-20.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface TopicListOfDynamic : CommonViewController
@property (weak, nonatomic) IBOutlet UITableView *dynamicPageTableView;
@property (strong, nonatomic) NSString * topic;
@end
