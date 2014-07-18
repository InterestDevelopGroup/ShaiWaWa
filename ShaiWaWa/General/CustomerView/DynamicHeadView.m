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
        
        _babyTop = [[UIView alloc] initWithFrame:CGRectMake(0, 7, 299, 54)];
        //_babyTop.backgroundColor = [UIColor whiteColor];

        _touXiangImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, 45, 45)];
        _touXiangImg.image = [UIImage imageNamed:@"baby_baobei.png"];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 54, 16)];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor colorWithRed:103/255.0 green:192/255.0 blue:15/255.0 alpha:1.0];
        _nameLabel.text = @"小龙李";
        
        _olderLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 34, 66, 13)];
        _olderLabel.backgroundColor = [UIColor clearColor];
        _olderLabel.font = [UIFont systemFontOfSize:10];
        _olderLabel.textColor = [UIColor lightGrayColor];
        _olderLabel.text = @"2年零13个月";
        
        [_babyTop addSubview:_touXiangImg];
        [_babyTop addSubview:_nameLabel];
        [_babyTop addSubview:_olderLabel];
        [self addSubview:_babyTop];
        
        _imgOrVideoScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 66, 299, 145)];
        _imgOrVideoScrollView.contentSize = CGSizeMake(299, 145);
        _imgOrVideoScrollView.backgroundColor = [UIColor clearColor];
        _imgOrVideoScrollView.showsHorizontalScrollIndicator = NO;
        _imgOrVideoScrollView.showsVerticalScrollIndicator = NO;
        _imgOrVideoScrollView.directionalLockEnabled = YES;
        
        [self addSubview:_imgOrVideoScrollView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 212, 299, 149)];
        //_contentView.backgroundColor = [UIColor whiteColor];
        _releaseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 3, 76, 17)];
        _releaseNameLabel.backgroundColor = [UIColor clearColor];
        _releaseNameLabel.font = [UIFont systemFontOfSize:11];
        _releaseNameLabel.textColor = [UIColor colorWithRed:103/255.0 green:192/255.0 blue:15/255.0 alpha:1.0];
        _releaseNameLabel.text = @"老李头(爸爸)";
        
        _releaseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(96, 3, 76, 17)];
        _releaseTimeLabel.backgroundColor = [UIColor clearColor];
        _releaseTimeLabel.font = [UIFont systemFontOfSize:11];
        _releaseTimeLabel.textColor = [UIColor lightGrayColor];
        _releaseTimeLabel.text = @"刚才";
        
        _addrLabel = [[UILabel alloc] initWithFrame:CGRectMake(29, 23, 263, 17)];
        _addrLabel.backgroundColor = [UIColor clearColor];
        _addrLabel.font = [UIFont systemFontOfSize:11];
        _addrLabel.textColor = [UIColor lightGrayColor];
        _addrLabel.text = @"上海市 浦东新区 晨晖路1001号附近";
        
        _locationImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 24, 12, 16)];
        _locationImg.image = [UIImage imageNamed:@"square_zizhi.png"];
        
        _contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(12, 34, 280, 82)];
        _contentTextView.backgroundColor = [UIColor clearColor];
        _contentTextView.font = [UIFont systemFontOfSize:10];
        _contentTextView.editable = NO;
        _contentTextView.showsHorizontalScrollIndicator =NO;
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.scrollEnabled = NO;
        _contentTextView.textColor = [UIColor darkGrayColor];
        _contentTextView.text = @"一二三四五六七八九十，一二三四五六七八九十，一二三四五六七八九十，一二三四五六七八九十，一二三四五六七八九十，一二三四五六七八九十，一二三四五六七八九十，一二三四五六七八九十，一二三四五六七八九十，一二三四五六七八九十。一二三四五六七八九十";
        
        _praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_praiseButton setBackgroundImage:[UIImage imageNamed:@"square_xihuan.png"] forState:UIControlStateNormal];
        [_praiseButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_praiseButton setTitle:@"261" forState:UIControlStateNormal];
        _praiseButton.titleLabel.font = [UIFont systemFontOfSize:10];
        _praiseButton.titleLabel.backgroundColor = [UIColor clearColor];
        _praiseButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        _praiseButton.frame = CGRectMake(12, 119, 55, 21);
        
        _praiseUserView = [[UIView alloc] initWithFrame:CGRectMake(75, 119, 85, 21)];
        _praiseUserView.backgroundColor = [UIColor clearColor];
        
        _praiseUserFirstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _praiseUserFirstBtn.frame = CGRectMake(8, 0, 21, 21);
        [_praiseUserFirstBtn setImage:[UIImage imageNamed:@"square_pic-7.png"] forState:UIControlStateNormal];
        _praiseUserSecondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _praiseUserSecondBtn.frame = CGRectMake(33, 0, 21, 21);
        [_praiseUserSecondBtn setImage:[UIImage imageNamed:@"square_pic-8.png"] forState:UIControlStateNormal];
        _praiseUserThirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _praiseUserThirdBtn.frame = CGRectMake(58, 0, 21, 21);
        [_praiseUserThirdBtn setImage:[UIImage imageNamed:@"square_pic-9.png"] forState:UIControlStateNormal];
        [_praiseUserView addSubview:_praiseUserFirstBtn];
        [_praiseUserView addSubview:_praiseUserSecondBtn];
        [_praiseUserView addSubview:_praiseUserThirdBtn];
        
        _pinLunButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pinLunButton.frame = CGRectMake(217, 120, 40, 19);
        [_pinLunButton setImage:[UIImage imageNamed:@"square_pinglun-2.png"] forState:UIControlStateNormal];
        [_pinLunButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_pinLunButton setTitle:@"261" forState:UIControlStateNormal];
        _pinLunButton.titleLabel.font = [UIFont systemFontOfSize:10];
        _pinLunButton.titleLabel.backgroundColor = [UIColor clearColor];
        
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.frame = CGRectMake(265, 119, 21, 21);
        [_moreButton setImage:[UIImage imageNamed:@"square_pinglun-3.png"] forState:UIControlStateNormal];
        
        [_contentView addSubview:_releaseNameLabel];
        [_contentView addSubview:_releaseTimeLabel];
        [_contentView addSubview:_addrLabel];
        [_contentView addSubview:_locationImg];
        [_contentView addSubview:_contentTextView];
        [_contentView addSubview:_praiseButton];
        [_contentView addSubview:_praiseUserView];
        [_contentView addSubview:_pinLunButton];
        [_contentView addSubview:_moreButton];
        [self addSubview:_contentView];
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
