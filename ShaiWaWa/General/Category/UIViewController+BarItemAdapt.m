//
//  UIViewController+BarItemAdapt.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UIViewController+BarItemAdapt.h"

@implementation UIViewController (BarItemAdapt)
- (void)setLeftCusBarItem:(NSString *)imageName action:(SEL)selector
{
    if ([OSHelper iOS7]) {
        [self setLeftCustomBarItem:@"square_back" action:nil imageEdgeInsets:UIEdgeInsetsMake(0, -70, 0, 0)];
    }
    else
    {
        [self setLeftCustomBarItem:@"square_back" action:nil imageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
    }
}
@end
