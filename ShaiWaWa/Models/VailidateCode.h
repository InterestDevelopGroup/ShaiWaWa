//
//  VailidateCode.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VailidateCode : NSObject<NSCopying, NSCoding> 
{
    NSString *validate_id;
    NSString *phone;            //手机号码
    NSString *create_time;      //创建验证日期
    NSString *timer;            //发送次数
    NSString *validateCode;     //验证码
}

@property (nonatomic, strong) NSString *validate_id;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, strong) NSString *timer;
@property (nonatomic, strong) NSString *validateCode;
@end
