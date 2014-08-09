//
//  BabySelectListViewController.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
typedef void(^BabyBlock)(NSString *);
@interface BabySelectListViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UITableView *myBabyList;
@property (nonatomic, strong) BabyBlock babyAvatarBlock;
@property (nonatomic, strong) BabyBlock babyNameBlock;
@property (nonatomic, strong) BabyBlock babyIdBlock;
@end
