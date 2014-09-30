//
//  ImageDisplayView.m
//  ShaiWaWa
//
//  Created by Carl on 14-8-31.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ImageDisplayView.h"
#import "UIImageView+WebCache.h"
@implementation ImageDisplayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame withPath:(NSString *)path
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        if([path hasPrefix:@"http"])
        {
            [imageView sd_setImageWithURL:[NSURL URLWithString:path]];
        }
        else
        {
            imageView.image = [UIImage imageWithContentsOfFile:path];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:imageView];
        imageView = nil;
    }
    return self;

}

- (id)initWithFrame:(CGRect)frame withPath:(NSString *)path withAllImages:(NSArray *)images
{
    self = [super initWithFrame:frame];
    if (self) {
        _path = path;
        _images = images;
        
        UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        scrollView.pagingEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        
        for(int i = 0; i < [images count]; i++)
        {
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake( i * CGRectGetWidth(self.bounds),0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
            NSString * path = images[i];
            if([path hasPrefix:@"http"])
            {
                [imageView sd_setImageWithURL:[NSURL URLWithString:path]];
            }
            else
            {
                imageView.image = [UIImage imageWithContentsOfFile:path];
            }
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:tap];
            tap = nil;
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            [scrollView addSubview:imageView];
            imageView = nil;

        }
        
        [scrollView setContentSize:CGSizeMake([images count] * CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        int index = [images indexOfObject:_path];
        [scrollView scrollRectToVisible:CGRectMake(index * CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) animated:NO];
        
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


- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    [self dismiss];
}

@end
