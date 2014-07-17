//
//  DynamicHeadView.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-17.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "DynamicHeadView.h"

@implementation DynamicHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        @property (nonatomic,retain) UIView *babyTop;
        @property (nonatomic,retain) UIImageView *touXiangImg;
        @property (nonatomic,retain) UILabel *nameLabel;
        @property (nonatomic,retain) UILabel *olderLabel;
        
        @property (nonatomic,retain) UIScrollView *imgOrVideoScrollView;
        
        @property (nonatomic,retain) UIView *contentView;
        @property (nonatomic,retain) UILabel *releaseNameLabel;
        @property (nonatomic,retain) UILabel *releaseTimeLabel;
        @property (nonatomic,retain) UILabel *addrLabel;
        @property (nonatomic,retain) UIImageView *locationImg;
        @property (nonatomic,retain) UITextView *contentTextView;
        @property (nonatomic,retain) UIButton  *praiseButton;
        @property (nonatomic,retain) UIView  *praiseUserView;
        @property (nonatomic,retain) UIButton  *praiseUserFirstBtn;
        @property (nonatomic,retain) UIButton  *praiseUserSecondBtn;
        @property (nonatomic,retain) UIButton  *praiseUserThirdBtn;
        @property (nonatomic,retain) UIButton  *pinLunButton;
        @property (nonatomic,retain) UIButton  *moreButton;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
