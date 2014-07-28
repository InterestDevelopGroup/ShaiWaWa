//
//  TheThirdPartyLoginView.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^XinLangBlock)(void);
typedef void(^QqBlock)(void);

@interface TheThirdPartyLoginView : UIView

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIButton *xinlanButton;
@property (nonatomic,retain) UIButton *qqButton;

@property (nonatomic,strong) XinLangBlock xinlanBlock;
@property (nonatomic,strong) QqBlock qqBlock;
@end
