//
//  UserDefault.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-22.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfo.h"

@interface UserDefault : NSObject

+(UserDefault *)sharedInstance ;//单例模式
//strong = copy + retain
@property (nonatomic, strong) UserInfo *userInfo;

//-(UserInfo *)userInfo;
//
//-(void)setUser : (UserInfo *) userInfo;
@end
