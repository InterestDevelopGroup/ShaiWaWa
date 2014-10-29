//
//  MyCollectionViewController.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-11.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface MyCollectionViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myFavoriveList;
@property (weak, nonatomic) IBOutlet UIView *grayShareView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
- (IBAction)hideGayShareV:(id)sender;
@end
