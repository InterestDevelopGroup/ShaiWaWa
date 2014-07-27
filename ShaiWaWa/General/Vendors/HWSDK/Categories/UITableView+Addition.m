//
//  UITableView+Addition.m
//  CarLife
//
//  Created by Carl on 14-4-1.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UITableView+Addition.h"

@implementation UITableView (Addition)
- (void)clearSeperateLine
{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
    view = nil;
}

- (void)registerNibWithName:(NSString *)nibName reuseIdentifier:(NSString *)identifier
{
    if(nibName == nil || [nibName length] == 0)
    {
        NSLog(@"The nib name is nil");
        return ;
    }
    if(identifier == nil || [identifier length] == 0)
        identifier = @"Cell";
    UINib * nib = [UINib nibWithNibName:nibName bundle:[NSBundle bundleForClass:NSClassFromString(nibName)]];
    [self registerNib:nib forCellReuseIdentifier:identifier];
    nib = nil;
}
@end
