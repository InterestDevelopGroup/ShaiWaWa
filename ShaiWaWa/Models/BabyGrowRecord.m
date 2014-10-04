//
//  BabyGrowRecord.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-9-27.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//  

#import "BabyGrowRecord.h"

@implementation BabyGrowRecord

- (id)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.add_time = dict[@"add_time"];
        self.baby_id = dict[@"baby_id"];
        self.body_type = [dict[@"body_type"] intValue];
        self.height = dict[@"height"];
        self.record_id = dict[@"record_id"];
        self.uid = dict[@"uid"];
        self.weight = dict[@"weight"];
    }
    return self;
}

@end
