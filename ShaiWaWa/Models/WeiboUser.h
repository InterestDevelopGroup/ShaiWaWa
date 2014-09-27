//
//  WeiboUser.h
//  ShaiWaWa
//
//  Created by Carl on 14-9-24.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface WeiboUser : BaseModel
@property (nonatomic,strong) NSString * uid;
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * is_auth;
@property (nonatomic,strong) NSString * profile_image_url;
@property (nonatomic,strong) NSString * avatar;
@end
