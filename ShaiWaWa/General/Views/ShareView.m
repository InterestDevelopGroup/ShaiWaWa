//
//  ShareView.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ShareView.h"

#import "ShareManager.h"

@implementation ShareView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _shareToLabel = [[UILabel alloc] init];
        _shareToLabel.text = @"分享到";
        _shareToLabel.font = [UIFont systemFontOfSize:15];
        _shareToLabel.textColor = [UIColor darkGrayColor];
        _shareToLabel.frame = CGRectMake(14, 10, 58, 21);
        _shareToLabel.backgroundColor = [UIColor clearColor];
        
        _weiXinButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weiXinButton setFrame:CGRectMake(20, 39, 64, 64)];
        [_weiXinButton setImage:[UIImage imageNamed:@"square_fenxiang-1.png"] forState:UIControlStateNormal];
        [_weiXinButton addTarget:self action:@selector(touchEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        _weiXinCycleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_weiXinCycleButton setFrame:CGRectMake(92, 39, 64, 64)];
        [_weiXinCycleButton setImage:[UIImage imageNamed:@"square_fenxiang-2.png"] forState:UIControlStateNormal];
        [_weiXinCycleButton addTarget:self action:@selector(touchEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        _xinLanWbButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xinLanWbButton setFrame:CGRectMake(164, 39, 64, 64)];
        [_xinLanWbButton setImage:[UIImage imageNamed:@"square_fenxiang-3.png"] forState:UIControlStateNormal];
        [_xinLanWbButton addTarget:self action:@selector(touchEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        _qzoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qzoneButton setFrame:CGRectMake(236, 39, 64, 64)];
        [_qzoneButton setImage:[UIImage imageNamed:@"square_fenxiang-4.png"] forState:UIControlStateNormal];
        [_qzoneButton addTarget:self action:@selector(touchEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        _collectionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_collectionButton setFrame:CGRectMake(13, 119, 93, 28)];
        [_collectionButton setImage:[UIImage imageNamed:@"square_shoucang.png"] forState:UIControlStateNormal];
        [_collectionButton addTarget:self action:@selector(touchEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        _reportButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_reportButton setFrame:CGRectMake(114, 119, 93, 28)];
        [_reportButton setImage:[UIImage imageNamed:@"square_jubao.png"] forState:UIControlStateNormal];
        [_reportButton addTarget:self action:@selector(touchEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setFrame:CGRectMake(215, 119, 93, 28)];
        [_deleteButton setImage:[UIImage imageNamed:@"square_shanchu.png"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(touchEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_shareToLabel];
        [self addSubview:_weiXinButton];
        [self addSubview:_weiXinCycleButton];
        [self addSubview:_xinLanWbButton];
        [self addSubview:_qzoneButton];
        [self addSubview:_collectionButton];
        [self addSubview:_reportButton];
        [self addSubview:_deleteButton];
        
        
    }
    return self;
}

- (void)touchEvent:(id)sender
{
    if (sender == _weiXinButton)
    {
        [[ShareManager sharePlatform] shareToWeiXin];
//        _weiXinCycleBlock();
    }
    else if (sender == _weiXinCycleButton)
    {
        [[ShareManager sharePlatform] shareToWeiXinCycle];
//        _weiXinCycleBlock();
    }
    else if (sender == _xinLanWbButton)
    {
        [[ShareManager sharePlatform] shareToSinaWeiBo];
//        _xinLanWbBlock();
    }
    else if (sender == _qzoneButton)
    {
        [[ShareManager sharePlatform] shareToQzone];
//        _qzoneBlock();
    }
    else if (sender == _collectionButton)
    {
//        _collectionBlock();
    }
    else if (sender == _reportButton)
    {
//        _reportBlock();
    }
    else if (sender == _deleteButton)
    {
        
        _deleteBlock(_name);
    }
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
