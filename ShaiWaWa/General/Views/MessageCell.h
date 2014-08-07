//
//  MessageCell.h
//  ShaiWaWa
//
//  Created by Cheung on 14-7-20.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *sendImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *receiveImgView;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIButton *ignoreButton;
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;

@end
