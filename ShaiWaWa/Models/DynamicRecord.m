//
//  DynamicRecord.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "DynamicRecord.h"

@implementation DynamicRecord
@synthesize rid,babyInfo,userInfo,visibility,content,address,longitude,latitude,add_time;
- (id)copyWithZone:(NSZone *)zone
{
	DynamicRecord *dynamicRecord = [[[self class] allocWithZone:zone] init];
	dynamicRecord.rid = [[self rid] copy];
    
	return dynamicRecord;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:rid forKey:@"rid"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        rid = [aDecoder decodeObjectForKey:@"rid"];
        
    }
    return self;
}


@end
