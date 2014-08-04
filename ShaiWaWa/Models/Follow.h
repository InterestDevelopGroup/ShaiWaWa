//
//  Follow.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo,BabyInfo;
@interface Follow : NSObject<NSCopying, NSCoding> 
{
    NSString *follow_id;        //关注id
    BabyInfo *babyInfo;
    UserInfo *userInfo;
    NSString *add_time;         //关注时间
}

@property (nonatomic, strong) NSString *follow_id;
@property (nonatomic, strong) BabyInfo *babyInfo;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *add_time;
@end
