//
//  DynamicCell.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "DynamicCell.h"

@implementation DynamicCell

- (void)awakeFromNib
{
    [self layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    if (!_scrollView.hidden)
    {
        [super layoutSubviews];
        return;
    }
//    _detailView.frame = CGRectMake(_detailView.frame.origin.x, _detailView.frame.origin.y - 134, _detailView.bounds.size.width, _detailView.bounds.size.height);
//    self.bounds = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 134);
}

@end
