//
//  UIView+CutLayer.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (CutLayer)

/**
	把层切成圆角
	@param radius 圆角半径
	@param masks 是否有边框
	@param border 边界宽度
 */
- (void)changeLayerToRoundWithCornerRadius:(float)radius
                             MasksToBounds:(BOOL)masks
                               BorderWidth:(float)border;

/**
 *  截图
 *
 *  @return 图片
 */
- (UIImage *)cutTheLayerToImage;

/**
 *  截图
 *
 *  @return 图片
 */
- (UIImage *)cutTheScrollLayerToImage;

@end
