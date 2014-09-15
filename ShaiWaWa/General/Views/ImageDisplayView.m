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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
