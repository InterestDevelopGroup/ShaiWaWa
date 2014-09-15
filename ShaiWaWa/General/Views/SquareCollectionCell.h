//
//  SquareCollectionCell.h
//  ShaiWaWa
//
//  Created by Carl on 14-9-2.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SquareCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *babyImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end
