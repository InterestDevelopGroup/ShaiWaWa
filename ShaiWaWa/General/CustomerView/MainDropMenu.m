//
//  MainDropMenu.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-11.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MainDropMenu.h"

@implementation MainDropMenu
@synthesize allButton,onlyMineButton,specialCareButton,searchDyButton;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        allButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [allButton setFrame:CGRectMake(0, 0, 79, 80)];
        [allButton setImage:[UIImage imageNamed:@"main_quanbudongtai.png"] forState:UIControlStateNormal];
        [self addSubview:allButton];
        
        onlyMineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [onlyMineButton setFrame:CGRectMake(80, 0, 79, 80)];
        [onlyMineButton setImage:[UIImage imageNamed:@"main_wodebaobao.png"] forState:UIControlStateNormal];
        [self addSubview:onlyMineButton];
        
        specialCareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [specialCareButton setFrame:CGRectMake(160, 0, 79, 80)];
        [specialCareButton setImage:[UIImage imageNamed:@"main_tebieguanxin.png"] forState:UIControlStateNormal];
        [self addSubview:specialCareButton];
        
        searchDyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchDyButton setFrame:CGRectMake(240, 0, 80, 80)];
        [searchDyButton setImage:[UIImage imageNamed:@"main_sousuodongftai.png"] forState:UIControlStateNormal];
        [self addSubview:searchDyButton];
        
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
