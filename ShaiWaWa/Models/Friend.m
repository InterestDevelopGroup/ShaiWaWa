//
//  Friend.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "Friend.h"

@implementation Friend
//@synthesize column_id,friend_id,/*userInfo,*/type,add_time;
- (id)copyWithZone:(NSZone *)zone
{
	Friend *friend = [[[self class] allocWithZone:zone] init];
    friend.add_time = [[self add_time] copy];
    friend.avatar = [[self avatar] copy];
    friend.fid = [[self fid] copy];
    friend.friend_id = [[self friend_id] copy];
    friend.login_time = [[self login_time] copy];
    friend.phone = [[self phone] copy];
    friend.qq = [[self qq] copy];
    friend.register_time = [[self register_time] copy];
    friend.sex = [[self sex] copy];
    friend.sina_openID = [[self sina_openID] copy];
    friend.sww_number = [[self sww_number] copy];
    friend.tecent_openID = [[self tecent_openID] copy];
    friend.type = [[self type] copy];
    friend.username = [[self username] copy];
    friend.wechat = [[self wechat] copy];
    friend.weibo = [[self weibo] copy];
    
	return friend;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    /*
    [aCoder encodeObject:add_time forKey:@"add_time"];
    [aCoder encodeObject:avatar forKey:@"avatar"];
    [aCoder encodeObject:fid forKey:@"fid"];
    [aCoder encodeObject:friend_id forKey:@"friend_id"];
    [aCoder encodeObject:login_time forKey:@"login_time"];
    [aCoder encodeObject:phone forKey:@"phone"];
    [aCoder encodeObject:qq forKey:@"qq"];
    [aCoder encodeObject:register_time forKey:@"register_time"];
    [aCoder encodeObject:sex forKey:@"sex"];
    [aCoder encodeObject:sina_openID forKey:@"sina_openID"];
    [aCoder encodeObject:sww_number forKey:@"sww_number"];
    [aCoder encodeObject:tecent_openID forKey:@"tecent_openID"];
    [aCoder encodeObject:type forKey:@"type"];
    [aCoder encodeObject:username forKey:@"username"];
    [aCoder encodeObject:wechat forKey:@"wechat"];
    [aCoder encodeObject:weibo forKey:@"weibo"];
*/
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        /*
        add_time = [aDecoder decodeObjectForKey:@"friend_id"];
        avatar = [aDecoder decodeObjectForKey:@"friend_id"];
        fid = [aDecoder decodeObjectForKey:@"friend_id"];
        friend_id = [aDecoder decodeObjectForKey:@"friend_id"];
        login_time = [aDecoder decodeObjectForKey:@"friend_id"];
        phone = [aDecoder decodeObjectForKey:@"friend_id"];
        qq = [aDecoder decodeObjectForKey:@"friend_id"];
        register_time = [aDecoder decodeObjectForKey:@"friend_id"];
        sex = [aDecoder decodeObjectForKey:@"friend_id"];
        sina_openID = [aDecoder decodeObjectForKey:@"friend_id"];
        sww_number = [aDecoder decodeObjectForKey:@"friend_id"];
        tecent_openID = [aDecoder decodeObjectForKey:@"friend_id"];
        type = [aDecoder decodeObjectForKey:@"friend_id"];
        username = [aDecoder decodeObjectForKey:@"friend_id"];
        wechat = [aDecoder decodeObjectForKey:@"friend_id"];
        weibo = [aDecoder decodeObjectForKey:@"friend_id"];
        */
    }
    return self;
}
@end
