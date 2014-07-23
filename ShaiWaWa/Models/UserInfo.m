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

- (id)copyWithZone:(NSZone *)zone
{
	UserInfo *userInfo = [[[self class] allocWithZone:zone] init];
	userInfo.username = [[self username] copy];
	userInfo.password = [[self password] copy];
	return userInfo;
}
@end
