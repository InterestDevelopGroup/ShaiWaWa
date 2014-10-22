//
//  PublishImageView.m
//  ShaiWaWa
//
//  Created by Carl on 14-8-21.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PublishImageView.h"
#import "VideoConvertHelper.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
@implementation PublishImageView

- (id)initWithFrame:(CGRect)frame withPath:(NSString *)path
{
    if((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        self.path = path;
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(4, 4, CGRectGetWidth(frame) - 8, CGRectGetHeight(frame) - 8)];
        if(path == nil || [path length] == 0)
        {
            //imageView.image = [UIImage imageNamed:@"square_pic-3"];
        }
        else if([path hasSuffix:@"png"] || [path hasSuffix:@"jpg"])
        {
            
            if([path hasPrefix:@"http"])
            {
                [imageView sd_setImageWithURL:[NSURL URLWithString:path]];
            }
            else
            {
                imageView.image = [UIImage imageWithContentsOfFile:path];
            }
        }
        else if ([path hasSuffix:@"mov"] || [path hasSuffix:@"mp4"])
        {
            //先判断是否是网络视频
            if([path hasPrefix:@"http"])
            {
                //如果是网络视频，则取得第一帧然后缓存
                if([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:path]])
                {
                    //[imageView sd_setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"square_pic-3"]];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:path]];
                }
                else
                {
                    //imageView.image = [UIImage imageNamed:@"square_pic-3"];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        UIImage * image = [[VideoConvertHelper sharedHelper] getVideoThumb:path];
                        [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:path]];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            imageView.image = image;
                        });
                    });

                }
            }
            else
            {
                //本地视频
                //imageView.image = [UIImage imageNamed:@"square_pic-3"];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    UIImage * image = [[VideoConvertHelper sharedHelper] getVideoThumb:path];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        imageView.image = image;
                    });
                });
            }

        }
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        tap = nil;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        
        CGRect closeRect = CGRectMake(CGRectGetWidth(frame) - 20, 0, 20, 20);
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
