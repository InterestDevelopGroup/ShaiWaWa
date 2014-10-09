//
//  BabyListCell.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BabyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *focusImageView;
@property (strong, nonatomic) IBOutlet UIImageView *babyImage;
@property (strong, nonatomic) IBOutlet UILabel *babyNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *babySexImage;
@property (strong, nonatomic) IBOutlet UILabel *babyOldLabel;
@property (weak, nonatomic) IBOutlet UILabel *age;


@end
