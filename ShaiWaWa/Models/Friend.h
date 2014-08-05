//
//  Friend.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;
@interface Friend : NSObject<NSCopying, NSCoding> 
{
    NSString *column_id;    //id
    NSString *friend_id;    //朋友id
    UserInfo *userInfo;
    NSString *type;         //关系类型(1:普通朋友，2:配偶)
    NSString *add_time;     //申请时间
    
}

@property (nonatomic, strong) NSString *column_id;
@property (nonatomic, strong) NSString *friend_id;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *add_time;

@end
