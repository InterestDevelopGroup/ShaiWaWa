//
//  NetCell.m
//  tableView网格表示
//
//  Created by Carl_Huang on 14-9-28.
//  Copyright (c) 2014年 Vison. All rights reserved.
//

#import "NetCell.h"
#import "BabyGrowRecord.h"

@implementation NetCell

- (void)awakeFromNib
{
    _recordDay.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0].CGColor;
    _recordDay.layer.borderWidth = 0.5;
    _weight.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0].CGColor;
    _weight.layer.borderWidth = 0.5;
    _height.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0].CGColor;
    _height.layer.borderWidth = 0.5;
    _bodyType.layer.borderColor = [UIColor colorWithRed:223/255.0 green:223/255.0 blue:223/255.0 alpha:1.0].CGColor;
    _bodyType.layer.borderWidth = 0.5;
}

- (void)setBabyGrowRecord:(BabyGrowRecord *)babyGrowRecord
{
    _babyGrowRecord = babyGrowRecord;
    _recordDay.text = babyGrowRecord.add_time;
    _height.text = babyGrowRecord.height;
    _weight.text = babyGrowRecord.weight;
    NSString *bodyType = nil;
    switch (babyGrowRecord.body_type) {
        case 1:
            bodyType = @"基本正常";
            break;
        case 2:
            bodyType = @"非常完美";
            break;
        case 3:
            bodyType = @"偏瘦";
            break;
        case 4:
            bodyType = @"偏胖";
            break;
        case 5:
            bodyType = @"偏高";
            break;
        case 6:
            bodyType = @"偏矮";
            break;
            
        default:
            bodyType = @"未知";
            break;
    }
    _bodyType.text = bodyType;
    
}

@end
