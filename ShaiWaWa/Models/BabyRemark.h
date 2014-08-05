//
//  BabyRemark.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BabyInfo,UserInfo;
@interface BabyRemark : NSObject<NSCopying, NSCoding> 
{
    NSString *remark_id;            //备注id
    BabyInfo *babyInfo;
    UserInfo *userInfo;
    NSString *alias;                //标题
    NSString *remark;               //备注
    NSString *add_time;             //备注时间
}

@property (nonatomic, strong) NSString *remark_id;
@property (nonatomic, strong) BabyInfo *babyInfo;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *add_time;

@end
