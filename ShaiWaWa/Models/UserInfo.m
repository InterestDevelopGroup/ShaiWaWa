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
@synthesize uid,phone,sex,sww_number;
- (id)copyWithZone:(NSZone *)zone
{
	UserInfo *userInfo = [[[self class] allocWithZone:zone] init];
	userInfo.username = [[self username] copy];
	userInfo.password = [[self password] copy];
    userInfo.uid = [[self uid] copy];
	userInfo.phone = [[self phone] copy];
    userInfo.sex = [[self sex] copy];
	userInfo.sww_number = [[self sww_number] copy];
	return userInfo;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:username forKey:@"username"];
    [aCoder encodeObject:password forKey:@"pwd"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        username = [aDecoder decodeObjectForKey:@"username"];
        password = [aDecoder decodeObjectForKey:@"pwd"];
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
