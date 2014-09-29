//
//  NetCell.h
//  tableView网格表示
//
//  Created by Carl_Huang on 14-9-28.
//  Copyright (c) 2014年 Vison. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BabyGrowRecord;
@interface NetCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *recordDay;
@property (weak, nonatomic) IBOutlet UILabel *height;
@property (weak, nonatomic) IBOutlet UILabel *weight;
@property (weak, nonatomic) IBOutlet UILabel *bodyType;

@property (nonatomic,strong) BabyGrowRecord *babyGrowRecord;


@end
