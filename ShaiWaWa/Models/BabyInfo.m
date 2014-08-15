//
//  BabyInfo.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-2.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BabyInfo.h"
#import "UserInfo.h"

@implementation BabyInfo
@synthesize baby_ID;
@synthesize uid;
@synthesize fid;
@synthesize mid;
@synthesize baby_name;
@synthesize avatar;
@synthesize sex;
@synthesize birthDate;
@synthesize nickName;
@synthesize country;
@synthesize province;
@synthesize city;
@synthesize birth_height;
@synthesize birth_weight;
@synthesize backGround;
@synthesize add_time;

- (id)copyWithZone:(NSZone *)zone
{
    BabyInfo *babyInfo = [[[self class] allocWithZone:zone] init];
    babyInfo.baby_ID = [[self baby_ID] copy];
    babyInfo.uid = [[self uid] copy];
    babyInfo.fid = [[self fid] copy];
    babyInfo.mid = [[self mid] copy];
    babyInfo.baby_name = [[self baby_name] copy];
    babyInfo.avatar = [[self avatar] copy];
    babyInfo.sex = [[self sex] copy];
    babyInfo.birthDate = [[self birthDate] copy];
    babyInfo.nickName = [[self nickName] copy];
    babyInfo.country = [[self country] copy];
    babyInfo.province =[[self province] copy];
    babyInfo.city = [[self city] copy];
    babyInfo.birth_height = [[self birth_height] copy];
    babyInfo.birth_weight = [[self birth_weight] copy];
    babyInfo.backGround = [[self backGround] copy];
    babyInfo.add_time = [[self add_time] copy];
	return babyInfo;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:baby_ID forKey:@"baby_ID"];
    [aCoder encodeObject:uid forKey:@"uid"];
    [aCoder encodeObject:fid forKey:@"fid"];
    [aCoder encodeObject:mid forKey:@"mid"];
    [aCoder encodeObject:baby_name forKey:@"baby_name"];
    [aCoder encodeObject:avatar forKey:@"avatar"];
    
    [aCoder encodeObject:sex forKey:@"sex"];
    [aCoder encodeObject:birthDate forKey:@"birthDate"];
    [aCoder encodeObject:nickName forKey:@"nickName"];
    [aCoder encodeObject:country forKey:@"country"];
    [aCoder encodeObject:province forKey:@"province"];
    [aCoder encodeObject:city forKey:@"city"];
    [aCoder encodeObject:birth_height forKey:@"birth_height"];
    [aCoder encodeObject:birth_weight forKey:@"birth_weight"];
    [aCoder encodeObject:backGround forKey:@"backGround"];
    [aCoder encodeObject:add_time forKey:@"add_time"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        baby_ID = [aDecoder decodeObjectForKey:@"baby_ID"];
        
        uid = [aDecoder decodeObjectForKey:@"uid"];
        fid = [aDecoder decodeObjectForKey:@"fid"];
        mid = [aDecoder decodeObjectForKey:@"mid"];
        baby_name = [aDecoder decodeObjectForKey:@"baby_name"];
        avatar = [aDecoder decodeObjectForKey:@"avatar"];
        sex = [aDecoder decodeObjectForKey:@"sex"];
        birthDate = [aDecoder decodeObjectForKey:@"birthDate"];
        nickName = [aDecoder decodeObjectForKey:@"nickName"];
        country = [aDecoder decodeObjectForKey:@"country"];
        province = [aDecoder decodeObjectForKey:@"province"];
        city = [aDecoder decodeObjectForKey:@"city"];
        birth_height = [aDecoder decodeObjectForKey:@"birth_height"];
        birth_weight = [aDecoder decodeObjectForKey:@"birth_weight"];
        backGround = [aDecoder decodeObjectForKey:@"backGround"];
        add_time = [aDecoder decodeObjectForKey:@"add_time"];
    }
    return self;
}

@end
