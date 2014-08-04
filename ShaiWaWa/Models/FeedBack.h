//
//  FeedBack.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;
@interface FeedBack : NSObject<NSCopying, NSCoding> 
{
    NSString *feedBack_id;          //反馈ID
    UserInfo *userInfo;
    NSString *content;              //反馈内容
    NSString *add_time;             //反馈时间
}

@property (nonatomic, strong) NSString *feedBack_id;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *add_time;

@end
