//
//  RecordComment.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DynamicRecord,UserInfo;
@interface RecordComment : NSObject<NSCopying, NSCoding> 
{
    NSString *comment_id;       //评论id
    DynamicRecord *dynamicRecord;
    UserInfo *userInfo;
    NSString *reply_id;         //回复id
    NSString *content;          //内容
    NSString *add_time;         //发表时间
}

@property (nonatomic, strong) NSString *comment_id;
@property (nonatomic, strong) DynamicRecord *dynamicRecord;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *reply_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *add_time;
@end
