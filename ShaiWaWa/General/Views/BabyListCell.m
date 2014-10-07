//
//  BabyListCell.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BabyListCell.h"

@implementation BabyListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews
{
    CGFloat nameX = _babyNameLabel.frame.origin.x;
    CGFloat nameY = _babyNameLabel.frame.origin.y;
    //根据文字的大小获得宽高
    CGSize nameSize = [_babyNameLabel.text sizeWithFont:[UIFont systemFontOfSize:17]];
    if (nameSize.width >160) {
        nameSize = CGSizeMake(160, nameSize.height);
    }
    //设置昵称的frame
    _babyNameLabel.frame = (CGRect){{nameX,nameY},nameSize};
    //设置性别
    CGFloat sexX = CGRectGetMaxX(_babyNameLabel.frame) + 10;
    CGFloat sexY = nameY + (nameSize.height - _babySexImage.frame.size.height) * 0.5;
    CGFloat sexW = _babySexImage.frame.size.width;
    CGFloat sexH = _babySexImage.frame.size.height;
    _babySexImage.frame = CGRectMake(sexX, sexY, sexW, sexH);
    
    //设置特别关注
    if (!_focusImageView.hidden) {
        CGFloat focusX = CGRectGetMaxX(_babySexImage.frame) + 10;
        CGFloat focusY = sexY;
        CGFloat focusW = _focusImageView.frame.size.width;
        CGFloat focusH = _focusImageView.frame.size.height;
        _focusImageView.frame = CGRectMake(focusX, focusY, focusW, focusH);
    }
}

@end
