//
//  DynamicRecord.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo,BabyInfo;
@interface DynamicRecord : NSObject<NSCopying, NSCoding> 
{
    NSString *rid;          //动态id
    BabyInfo *babyInfo;
    UserInfo *userInfo;
    NSString *visibility;   //是否可见(1:公开,2:仅亲友可见,3:仅父母可见)
    NSString *content;      //动态内容
    NSString *address;      //地点
    NSString *longitude;    //经度
    NSString *latitude;     //纬度
    NSString *add_time;     //发表时间
    
}

@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) BabyInfo *babyInfo;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *visibility;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *add_time;
@end
