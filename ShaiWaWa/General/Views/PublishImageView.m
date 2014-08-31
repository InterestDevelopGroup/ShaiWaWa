//
//  PublishImageView.m
//  ShaiWaWa
//
//  Created by Carl on 14-8-21.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PublishImageView.h"
#import "VideoConvertHelper.h"
@implementation PublishImageView

- (id)initWithFrame:(CGRect)frame withPath:(NSString *)path
{
    if((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        self.path = path;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, CGRectGetWidth(frame) - 8, CGRectGetHeight(frame) - 8)];
        if([path hasSuffix:@"png"] || [path hasSuffix:@"jpg"])
        {
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }
        else if ([path hasSuffix:@"mov"] || [path hasSuffix:@"mp4"])
        {
            imageView.image = [[VideoConvertHelper sharedHelper] getVideoThumb:path];
        }
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        tap = nil;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        
        CGRect closeRect = CGRectMake(CGRectGetWidth(frame) - 20, 0, 20, 20);
        UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = closeRect;
        closeBtn.backgroundColor = [UIColor clearColor];
        [closeBtn setImage:[UIImage imageNamed:@"main_cha"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        closeBtn = nil;
    }
    
    return self;
}

- (void)closeAction:(id)sender
{
    if(_deleteBlock && _path)
    {
        _deleteBlock(_path);
    }
    
    [IO deleteFileAtPath:_path];
    [self removeFromSuperview];
}

- (void)tapAction:(id)sender
{
    if(_tapBlock && _path)
    {
        _tapBlock(_path);
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
