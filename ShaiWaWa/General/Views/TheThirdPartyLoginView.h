//
//  TheThirdPartyLoginView.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "UserInfo.h"
typedef void (^UnbindBlock)(NSString * token,NSString * type);
typedef void (^BindBlock)(UserInfo * user);

@interface TheThirdPartyLoginView : UIView

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UIButton *xinlanButton;
@property (nonatomic,retain) UIButton *qqButton;

@property (nonatomic,copy) UnbindBlock unbindBlock;
@property (nonatomic,copy) BindBlock bindBlock;

@end
