//
//  Friend.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
//@class UserInfo;
@interface Friend : NSObject<NSCopying, NSCoding>
{
    NSString *add_time;        //申请时间
    NSString *avatar;
    NSString *fid;             //朋友id
    NSString *friend_id;
    NSString *login_time;
    NSString *phone;
    NSString *qq;
    NSString *register_time;
    NSString *sex;
    NSString *sina_openID;
    NSString *sww_number;
    NSString *tecent_openID;
    NSString *type;           //关系类型(1:普通朋友，2:配偶)
    NSString *username;
    NSString *wechat;
    NSString *weibo;
}
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *friend_id;
@property (nonatomic, strong) NSString *login_time;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *qq;
@property (nonatomic, strong) NSString *register_time;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *sina_openID;
@property (nonatomic, strong) NSString *sww_number;
@property (nonatomic, strong) NSString *tecent_openID;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *wechat;
@property (nonatomic, strong) NSString *weibo;
@end
