//
//  RecordComment.h
//  ShaiWaWa
//
//  Created by Carl on 14-8-27.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface RecordComment : BaseModel
@property (nonatomic,strong) NSString * uid;
@property (nonatomic,strong) NSString * comment_id;
@property (nonatomic,strong) NSString * avatar;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * username;
@property (nonatomic,strong) NSString * reply_id;
@property (nonatomic,strong) NSString * reply_list;
@property (nonatomic,strong) NSString * add_time;
@end
