//
//  RecordLike.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DynamicRecord,UserInfo;
@interface RecordLike : NSObject<NSCopying, NSCoding> 
{
    NSString *like_id;              //赞id
    DynamicRecord *dynamicRecord;
    UserInfo *userInfo;
    NSString *is_like;              //赞状态(1:赞 0:取消赞)
    NSString *add_time;             //赞时间
}

@property (nonatomic, strong) NSString *like_id;
@property (nonatomic, strong) DynamicRecord *dynamicRecord;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *is_like;
@property (nonatomic, strong) NSString *add_time;
@end
