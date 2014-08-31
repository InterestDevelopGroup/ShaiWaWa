//
//  UserInfo.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
@synthesize username;
@synthesize password;
@synthesize uid;
@synthesize phone;
@synthesize sex;
@synthesize sww_number;
@synthesize avatar;
@synthesize qq,weibo,wechat;
@synthesize sina_openId,tecent_openId;
@synthesize login_time,register_time;
@synthesize baby_count,record_count;
@synthesize favorite_count,friend_count;
- (id)copyWithZone:(NSZone *)zone
{
	UserInfo *userInfo = [[[self class] allocWithZone:zone] init];
	userInfo.username = [[self username] copy];
	userInfo.password = [[self password] copy];
    userInfo.uid = [[self uid] copy];
	userInfo.phone = [[self phone] copy];
    userInfo.sex = [[self sex] copy];
	userInfo.sww_number = [[self sww_number] copy];
    userInfo.avatar = [[self avatar] copy];
	userInfo.qq = [[self qq] copy];
    userInfo.weibo = [[self weibo] copy];
	userInfo.wechat = [[self wechat] copy];
    userInfo.sina_openId = [[self sina_openId] copy];
	userInfo.tecent_openId = [[self tecent_openId] copy];
    userInfo.login_time = [[self login_time] copy];
	userInfo.register_time = [[self register_time] copy];
    userInfo.baby_count = [[self baby_count] copy];
    userInfo.record_count = [[self record_count] copy];
    userInfo.favorite_count = [[self favorite_count] copy];
    userInfo.friend_count = [[self friend_count] copy];
	return userInfo;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:phone forKey:@"phone"];
    [aCoder encodeObject:password forKey:@"pwd"];
    [aCoder encodeObject:username forKey:@"username"];
    [aCoder encodeObject:sww_number forKey:@"sww_number"];
    [aCoder encodeObject:sex forKey:@"sex"];
    [aCoder encodeObject:uid forKey:@"uid"];
    [aCoder encodeObject:avatar forKey:@"avatar"];
    [aCoder encodeObject:qq forKey:@"qq"];
    [aCoder encodeObject:weibo forKey:@"weibo"];
    [aCoder encodeObject:wechat forKey:@"wechat"];
    [aCoder encodeObject:sina_openId forKey:@"sina_openId"];
    [aCoder encodeObject:tecent_openId forKey:@"tecent_openId"];
    [aCoder encodeObject:login_time forKey:@"login_time"];
    [aCoder encodeObject:register_time forKey:@"register_time"];
    [aCoder encodeObject:baby_count forKey:@"baby_count"];
    [aCoder encodeObject:record_count forKey:@"record_count"];
    [aCoder encodeObject:favorite_count forKey:@"favorite_count"];
    [aCoder encodeObject:friend_count forKey:@"friend_count"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.phone = [aDecoder decodeObjectForKey:@"phone"];
        self.password = [aDecoder decodeObjectForKey:@"pwd"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.sww_number = [aDecoder decodeObjectForKey:@"sww_number"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.qq = [aDecoder decodeObjectForKey:@"qq"];
        self.weibo = [aDecoder decodeObjectForKey:@"weibo"];
        self.wechat = [aDecoder decodeObjectForKey:@"wechat"];
        self.sina_openId = [aDecoder decodeObjectForKey:@"sina_openId"];
        self.tecent_openId = [aDecoder decodeObjectForKey:@"tecent_openId"];
        self.login_time = [aDecoder decodeObjectForKey:@"login_time"];
        self.register_time = [aDecoder decodeObjectForKey:@"register_time"];
        self.baby_count = [aDecoder decodeObjectForKey:@"baby_count"];
        self.record_count = [aDecoder decodeObjectForKey:@"record_count"];
        self.favorite_count = [aDecoder decodeObjectForKey:@"favorite_count"];
        self.friend_count = [aDecoder decodeObjectForKey:@"friend_count"];
    }
    return self;
}

- (UserInfo *)initWithName:(NSString *)_username and:(NSString *)_password
{
    self = [super init];
    if (self) {
        username = _username;
        password = _password;
    }
    return self;
}
@end
