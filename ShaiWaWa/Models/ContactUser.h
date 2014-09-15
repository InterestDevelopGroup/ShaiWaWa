//
//  ContactUser.h
//  ShaiWaWa
//
//  Created by Carl on 14-9-11.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface ContactUser : BaseModel
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * is_auth;
@property (nonatomic,strong) NSString * login_time;
@property (nonatomic,strong) NSString * phone;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * qq;
@property (nonatomic,strong) NSString * register_time;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSString * sina_openId;
@property (nonatomic,strong) NSString * sww_number;
@property (nonatomic,strong) NSString * tecent_openId;
@property (nonatomic,strong) NSString * uid;
@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * wechat;
@property (nonatomic,strong) NSString * weibo;
@end
