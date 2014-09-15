//
//  NotificationMsg.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BabyInfo,DynamicRecord;
@interface NotificationMsg : NSObject 
{
    NSString *notification_id;      //消息id
    NSString *msg_type;                 //消息类型
                                    //(1:动态被评论，2:动态被赞，3:申请成为好友，4:好友申请被批准，5:好友申请被拒绝，6:自己的宝宝有新动态，7:特别关注的宝宝有新动态，8:被@了)
    NSString *content;              //消息内容
    BabyInfo *babyInfo;
    NSString *send_uid;             //发送者
    NSString *receive_uid;          //接收者
    NSString *comment_id;           //评论编号
    DynamicRecord *dynamicRecord;
    NSString *remark;               //备注
    NSString *status;               //消息状态：0未读，1已读，2已处理
    NSString *add_time;             //发送时间
    NSString *read_time;            //查看时间
}


@property (nonatomic, strong) NSString *notification_id;
@property (nonatomic, strong) NSString *msg_type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) BabyInfo *babyInfo;
@property (nonatomic, strong) NSString *send_uid;
@property (nonatomic, strong) NSString *receive_uid;
@property (nonatomic, strong) NSString *comment_id;
@property (nonatomic, strong) DynamicRecord *dynamicRecord;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *add_time;
@property (nonatomic, strong) NSString *read_time;
@end
