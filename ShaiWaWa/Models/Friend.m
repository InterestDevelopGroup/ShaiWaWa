//
//  Friend.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "Friend.h"
#import "UserInfo.h"

@implementation Friend
@synthesize column_id,friend_id,userInfo,type,add_time;
- (id)copyWithZone:(NSZone *)zone
{
//    userInfo = [[UserInfo alloc] init];
	Friend *friend = [[[self class] allocWithZone:zone] init];
	friend.column_id = [[self column_id] copy];
    friend.friend_id = [[self friend_id] copy];
    friend.userInfo.uid = [userInfo.uid copy];
    friend.type = [[self type] copy];
    friend.add_time = [[self add_time] copy];
	return friend;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:column_id forKey:@"column_id"];
    [aCoder encodeObject:friend_id forKey:@"friend_id"];
    [aCoder encodeObject:userInfo.uid forKey:@"uid"];
    [aCoder encodeObject:type forKey:@"type"];
    [aCoder encodeObject:add_time forKey:@"add_time"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        column_id = [aDecoder decodeObjectForKey:@"column_id"];
        friend_id = [aDecoder decodeObjectForKey:@"friend_id"];
        userInfo.uid = [aDecoder decodeObjectForKey:@"uid"];
        type = [aDecoder decodeObjectForKey:@"type"];
        add_time = [aDecoder decodeObjectForKey:@"add_time"];

    }
    return self;
}
@end
