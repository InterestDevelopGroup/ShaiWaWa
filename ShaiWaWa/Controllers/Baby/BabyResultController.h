//
//  BabyResultController.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-10-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BabyResultController : UITableViewController
@property (nonatomic, strong) NSMutableArray *myBabyList;
@property (nonatomic, strong) NSMutableArray *friendsBabyList;
@property (nonatomic,copy) NSString *searchText;
@end
