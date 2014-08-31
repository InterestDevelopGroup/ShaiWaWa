//
//  CommonAlert.m
//  LingTong
//
//  Created by Carl on 14-3-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonAlert.h"
#define Overlay_Tag 10000
@implementation CommonAlert

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.transform = CGAffineTransformMakeScale(0.0, 0.0);
        UIView * overlay = [UIView new];
        overlay.userInteractionEnabled = YES;
        overlay.backgroundColor = [UIColor blackColor];
        overlay.alpha = 0.1;
        overlay.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        overlay.tag = Overlay_Tag;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [overlay addGestureRecognizer:tap];
        tap = nil;
        [self addSubview:overlay];
        overlay = nil;
    }
    return self;
}


- (void)show
{
    self.hidden = NO;
    
    [UIView animateWithDuration:.2 animations:^{
        [self viewWithTag:Overlay_Tag].alpha = .5;
        self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0/15 animations:^{
            self.transform = CGAffineTransformMakeScale(.9, .9);
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1.0/7.5 animations:^{
                self.transform = CGAffineTransformMakeScale(1.0, 1.0);
            }];
            
            
        }];
        
        
    }];
}

- (void)dismiss
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.3 animations:^{
        [self viewWithTag:1].alpha = 0.0;
        self.transform = CGAffineTransformMakeScale(0.0, 0.0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

@end
