//
//  ResponseHelper.m
//  ShaiWaWa
//
//  Created by Carl on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ResponseHelper.h"

@implementation ResponseHelper

+ (NSArray *)transformToBabyRecords:(NSArray *)arr
{
    if(arr == nil || [arr isEqual:[NSNull null]] || [arr count] == 0)
    {
        return @[];
    }
    NSMutableArray * results = [@[] mutableCopy];
    
    for(NSDictionary * dic in arr)
    {
        BabyRecord * record = [[BabyRecord alloc] init];
        record.baby_id = dic[@"baby_id"];
        record.uid = dic[@"uid"];
        record.rid = dic[@"rid"];
        record.add_time = dic[@"add_time"];
        record.content = dic[@"content"] == [NSNull null] ? @"" : dic[@"content"];
        record.address = dic[@"address"] == [NSNull null] ? @"" : dic[@"address"];
        record.latitude = dic[@"latitude"] == [NSNull null] ? @"" : dic[@"latitude"];
        record.longitude = dic[@"longitude"] == [NSNull null] ? @"" : dic[@"longitude"];
        record.visibility = dic[@"visibility"];
        record.baby_name = dic[@"baby_name"] == [NSNull null] ? @"" : dic[@"baby_name"];
        record.baby_nickname = dic[@"baby_nickname"] == [NSNull null] ? @"" : dic[@"baby_nickname"];
        record.like_count = dic[@"like_count"];
        record.is_like = dic[@"is_like"];
        record.comment_count = dic[@"comment_count"];
        record.images = dic[@"image"] == [NSNull null] ? @[] : dic[@"image"];
        record.video = dic[@"video"] == [NSNull null] ? @"" : dic[@"video"];
        record.audio = dic[@"audio"] == [NSNull null] ? @"" : dic[@"audio"];
        record.top_3_likes = dic[@"top_3_likes"] == [NSNull null] ? @[] : dic[@"top_3_likes"];
        record.user_avatar = dic[@"user_avatar"] == [NSNull null] ? @"" : dic[@"user_avatar"];
        record.avatar = dic[@"avatar"] == [NSNull null] ? @"" : dic[@"avatar"];
        record.username = dic[@"username"] == [NSNull null] ? @"" : dic[@"username"];
        record.birthday = dic[@"birthday"] == [NSNull null] ? @"" : dic[@"birthday"];
        record.baby_alias = dic[@"baby_alias"] == [NSNull null] ? @"" : dic[@"baby_alias"];
        [results addObject:record];
        record = nil;
    }
    return results;
}


+ (NSArray *)transformToRecordComments:(NSArray *)arr
{
    if(arr == nil || [arr isEqual:[NSNull null]] || [arr count] == 0)
    {
        return @[];
    }
    NSMutableArray * results = [@[] mutableCopy];
    
    for(NSDictionary * dic in arr)
    {
        RecordComment * comment = [[RecordComment alloc] init];
        comment.uid = dic[@"uid"];
        comment.username = dic[@"username"];
        comment.avatar = dic[@"avatar"];
        comment.content = dic[@"content"];
        comment.comment_id = dic[@"comment_id"];
        comment.reply_id = dic[@"reply_id"];
        comment.reply_list = dic[@"reply_list"] == [NSNull null] ? @[] : dic[@"reply_list"];
        comment.add_time = dic[@"add_time"];
        [results addObject:comment];
        comment = nil;
        
    }
    return results;
}

+ (NSArray *)transformToMessages:(NSArray *)arr
{
    if(arr == nil || [arr isEqual:[NSNull null]] || [arr count] == 0)
    {
        return @[];
    }
    NSMutableArray * results = [@[] mutableCopy];
    for(NSDictionary * dic in arr)
    {
        NotificationMsg * msg = [[NotificationMsg alloc] init];
        msg.fid = dic[@"fid"];
        msg.notification_id = dic[@"notification_id"];
        msg.add_time = dic[@"add_time"];
        msg.baby_id = dic[@"baby_id"];
        msg.comment_id = dic[@"comment_id"];
        msg.content = dic[@"content"];
        msg.like_id = dic[@"like_id"];
        msg.read_time = dic[@"read_time"];
        msg.receive_uid = dic[@"receive_uid"];
        msg.remark = dic[@"remark"];
        msg.requester_info = dic[@"requester_info"];
        msg.rid = dic[@"rid"];
        msg.send_uid = dic[@"send_uid"];
        msg.status = dic[@"status"];
        msg.type = dic[@"type"];
        [results addObject:msg];
    }
    return results;
}

@end
