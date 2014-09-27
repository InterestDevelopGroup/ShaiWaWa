//
//  BabyGrowRecord.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-9-27.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//  Baby成长记录的模型

#import "BaseModel.h"

typedef enum {
    kBabyTypeUnknow = 0,
    kBabyTypeNormal = 1,
    kBabyTypePerfect = 2,
    kBabyTypeLean = 3,
    kBabyTypeFat = 4,
    kBabyTypeTall = 5,
    kBabyTypeShort = 6
} babyType;


@interface BabyGrowRecord : BaseModel

@property (nonatomic,strong) NSString * add_time;
@property (nonatomic,strong) NSString * baby_id;
@property (nonatomic,assign) babyType body_type;
@property (nonatomic,strong) NSString * height;
@property (nonatomic,strong) NSString * record_id;
@property (nonatomic,strong) NSString * uid;
@property (nonatomic,strong) NSString * weight;

- (id)initWithDict:(NSDictionary *)dict;

@end
