//
//  Grow.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BabyInfo;
@class UserInfo;
@interface Grow : NSObject<NSCopying, NSCoding> 
{
    NSString *record_id;
    BabyInfo *babyInfo;
    UserInfo *userInfo;
    NSString *height;
    NSString *weight;
    NSString *add_time;
}

@property (nonatomic, strong) NSString *record_id;
@property (nonatomic, strong) BabyInfo *babyInfo;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *weight;
@property (nonatomic, strong) NSString *add_time;
@end
