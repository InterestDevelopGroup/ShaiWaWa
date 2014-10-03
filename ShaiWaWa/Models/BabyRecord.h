//
//  BabyRecord.h
//  ShaiWaWa
//
//  Created by Carl on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface BabyRecord : BaseModel
@property (nonatomic,strong) NSString * rid;
@property (nonatomic,strong) NSString * add_time;
@property (nonatomic,strong) NSString * baby_id;
@property (nonatomic,strong) NSString * uid;
@property (nonatomic,strong) NSString * visibility;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * longitude;
@property (nonatomic,strong) NSString * latitude;
@property (nonatomic,strong) NSString * like_count;
@property (nonatomic,strong) NSString * is_like;
@property (nonatomic,strong) NSString * comment_count;
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * baby_name;
@property (nonatomic,strong) NSString * baby_nickname;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSArray * top_3_likes;
@property (nonatomic,strong) NSArray * images;
@property (nonatomic,strong) NSString * video;
@property (nonatomic,strong) NSString * audio;
@property (nonatomic,strong) NSString * user_avatar;
@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * birthday;
@end
