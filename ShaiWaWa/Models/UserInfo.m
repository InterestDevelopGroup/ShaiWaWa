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
//@synthesize qq,weibo,wechat;
//@synthesize sina_openId,tecent_openId;
- (id)copyWithZone:(NSZone *)zone
{
	UserInfo *userInfo = [[[self class] allocWithZone:zone] init];
	userInfo.username = [[self username] copy];
	userInfo.password = [[self password] copy];
    userInfo.uid = [[self uid] copy];
	userInfo.phone = [[self phone] copy];
    userInfo.sex = [[self sex] copy];
	userInfo.sww_number = [[self sww_number] copy];
    
//    userInfo.avatar = [[self avatar] copy];
//	userInfo.qq = [[self qq] copy];
//    userInfo.weibo = [[self weibo] copy];
//	userInfo.wechat = [[self wechat] copy];
//    userInfo.sina_openId = [[self sina_openId] copy];
//	userInfo.tecent_openId = [[self tecent_openId] copy];
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
//    [aCoder encodeObject:qq forKey:@"qq"];
//    [aCoder encodeObject:weibo forKey:@"weibo"];
//    [aCoder encodeObject:wechat forKey:@"wechat"];
//    [aCoder encodeObject:sina_openId forKey:@"sina_openId"];
//    [aCoder encodeObject:tecent_openId forKey:@"tecent_openId"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        phone = [aDecoder decodeObjectForKey:@"phone"];
        password = [aDecoder decodeObjectForKey:@"pwd"];
        username = [aDecoder decodeObjectForKey:@"username"];
        sww_number = [aDecoder decodeObjectForKey:@"sww_number"];
        uid = [aDecoder decodeObjectForKey:@"uid"];
        sex = [aDecoder decodeObjectForKey:@"sex"];
        avatar = [aDecoder decodeObjectForKey:@"avatar"];
//        qq = [aDecoder decodeObjectForKey:@"qq"];
//        weibo = [aDecoder decodeObjectForKey:@"weibo"];
//        wechat = [aDecoder decodeObjectForKey:@"wechat"];
//        sina_openId = [aDecoder decodeObjectForKey:@"sina_openId"];
//        tecent_openId = [aDecoder decodeObjectForKey:@"tecent_openId"];
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
