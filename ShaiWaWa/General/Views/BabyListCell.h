//
//  BabyListCell.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BabyListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *babyImage;
@property (strong, nonatomic) IBOutlet UILabel *babyNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *babySexImage;
@property (strong, nonatomic) IBOutlet UILabel *babyOldLabel;
@end
