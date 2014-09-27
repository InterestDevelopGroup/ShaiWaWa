//
//  BabyInfo.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-2.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserInfo;
@interface BabyInfo : NSObject <NSCopying, NSCoding>
{
    NSString *baby_id;      //宝宝id
    NSString *uid;     //用户实体，获取用户ID
    NSString *fid;          //父亲id
    NSString *mid;          //母亲id
    NSString *baby_name;    //宝宝名称
    NSString *avatar;       //宝宝头像
    NSString *sex;          //性别(1:男 2:女)
    NSString *birthday;    //出生日期
    NSString *nickname;     //昵称
    NSString *country;      //国家
    NSString *province;     //所在身份
    NSString *city;         //所在城市
    NSString *birth_height; //出身身高
    NSString *birth_weight; //出生体重
    NSString *background;   //背景图片
    NSString *add_time;     //添加时间
}

@property(nonatomic, retain) NSString *baby_id;
@property(nonatomic, retain) NSString *uid;
@property(nonatomic, retain) NSString *fid;
@property(nonatomic, retain) NSString *mid;
@property(nonatomic, retain) NSString *baby_name;
@property(nonatomic, retain) NSString *avatar;
@property(nonatomic, retain) NSString *sex;
@property(nonatomic, retain) NSString *birthday;
@property(nonatomic, retain) NSString *nickname;
@property(nonatomic, retain) NSString *country;
@property(nonatomic, retain) NSString *province;
@property(nonatomic, retain) NSString *city;
@property(nonatomic, retain) NSString *birth_height;
@property(nonatomic, retain) NSString *birth_weight;
@property(nonatomic, retain) NSString *background;
@property(nonatomic, retain) NSString *add_time;
@property(nonatomic, retain) NSString * record_count;

@end
