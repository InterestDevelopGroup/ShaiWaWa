//
//  NotificationMsg.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationMsg : NSObject 
{

}
/**
 type 说明
 1 评论
 2 赞
 3 加好友
 4 同意请求
 5 被拒绝
 6 宝宝有新动态
 7 特别关注宝宝有动态
 8 被@了
 */
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *notification_id;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *baby_id;
@property (nonatomic, strong) NSString *send_uid;
@property (nonatomic, strong) NSString *receive_uid;
@property (nonatomic, strong) NSString *comment_id;
@property (nonatomic, strong) NSString *rid;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *read_time;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSDictionary *requester_info;
@property (nonatomic, strong) NSString * like_id;
@end
