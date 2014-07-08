//
//  UIView+CutLayer.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//


#import "UIView+CutLayer.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (CutLayer)

/**
 把层切成圆角
 @param radius 圆角半径
 @param masks 是否有边框
 @param border 边界宽度
 */
- (void)changeLayerToRoundWithCornerRadius:(float)radius
                             MasksToBounds:(BOOL)masks
                               BorderWidth:(float)border {
    [self.layer setOpaque:NO];
    [[self layer] setCornerRadius:radius];
    [[self layer] setMasksToBounds:masks];
    [[self layer] setBorderWidth:border];
}

/**
 *  截图
 *
 *  @return 图片
 */
- (UIImage *)cutTheLayerToImage {
    UIGraphicsBeginImageContext(self.layer.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  截图
 *
 *  @return 图片
 */
- (UIImage *)cutTheScrollLayerToImage {
    if ([self isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scroll = (UIScrollView *)self;
        UIImage* image = nil;
        
        UIGraphicsBeginImageContext(scroll.contentSize);
        {
            CGPoint savedContentOffset = scroll.contentOffset;
            CGRect savedFrame = scroll.frame;
            
            scroll.contentOffset = CGPointZero;
            scroll.frame = CGRectMake(0, 0, scroll.contentSize.width, scroll.contentSize.height);
            
            [scroll.layer renderInContext: UIGraphicsGetCurrentContext()];
            image = UIGraphicsGetImageFromCurrentImageContext();
            
            scroll.contentOffset = savedContentOffset;
            scroll.frame = savedFrame;
        }
        UIGraphicsEndImageContext();
        return image;
    }
    return nil;
}

@end
