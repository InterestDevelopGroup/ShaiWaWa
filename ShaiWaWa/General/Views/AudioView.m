//
//  AudioView.m
//  ShaiWaWa
//
//  Created by Carl on 14-9-22.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AudioView.h"

@implementation AudioView

- (id)initWithFrame:(CGRect)frame withPath:(NSString *)path
{
    self = [super initWithFrame:frame];
    if (self) {
        self.path = path;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame) - 10);
        [button setImage:[UIImage imageNamed:@"square_bofang-bg"] forState:UIControlStateNormal];
        [self addSubview:button];
        
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - 10) * .5, (CGRectGetHeight(frame) - 10) * .5, 10, 10)];
        imageView.image = [UIImage imageNamed:@"square_bofang"];
        [self addSubview:imageView];
        
        
        CGRect closeRect = CGRectMake(CGRectGetWidth(frame) - 20, 8, 15, 15);
        UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = closeRect;
        closeBtn.backgroundColor = [UIColor clearColor];
        [closeBtn setImage:[UIImage imageNamed:@"main_cha"] forState:UIControlStateNormal];
        closeBtn.tag = 10000;
        [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        closeBtn = nil;
        
    }
    return self;
}

- (void)setCloseHidden
{
    UIButton * closeBtn = (UIButton *)[self viewWithTag:10000];
    closeBtn.hidden = YES;
}


- (void)closeAction:(id)sender
{
    if(_deleteBlock)
    {
        _deleteBlock(_path);
    }
    
    if(_path)
    {
        [IO deleteFileAtPath:_path];
    }
    [self removeFromSuperview];
}

@end
