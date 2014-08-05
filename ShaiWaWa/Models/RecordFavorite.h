//
//  RecordFavorite.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DynamicRecord,UserInfo;
@interface RecordFavorite : NSObject<NSCopying, NSCoding> 
{
    NSString *favorite_id;          //收藏id
    DynamicRecord *dynamicRecord;
    UserInfo *userInfo;
    NSString *add_time;             //收藏时间
}

@property (nonatomic, strong) NSString *favorite_id;
@property (nonatomic, strong) DynamicRecord *dynamicRecord;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *add_time;

@end
