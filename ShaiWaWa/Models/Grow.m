//
//  Grow.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "Grow.h"

@implementation Grow
@synthesize record_id,babyInfo,userInfo,height,weight,add_time;

- (id)copyWithZone:(NSZone *)zone
{
	Grow *grow = [[[self class] allocWithZone:zone] init];
	grow.record_id = [[self record_id] copy];

	return grow;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:record_id forKey:@"record_id"];

}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        record_id = [aDecoder decodeObjectForKey:@"record_id"];

    }
    return self;
}


@end
