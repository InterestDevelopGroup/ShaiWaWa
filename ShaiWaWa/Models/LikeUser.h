//
//  LikeUser.h
//  ShaiWaWa
//
//  Created by Carl on 14-9-12.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface LikeUser : BaseModel
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * like_id;
@property (nonatomic,strong) NSString * baby_count;
@property (nonatomic,strong) NSString * uid;
@property (nonatomic,strong) NSString * username;
@end
