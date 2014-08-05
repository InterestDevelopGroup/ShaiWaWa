//
//  RecordReport.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DynamicRecord,UserInfo;
@interface RecordReport : NSObject<NSCopying, NSCoding> 
{
    NSString *report_id;     //举报id
    DynamicRecord *dynamicRecord;
    UserInfo *userInfo;
    NSString *type;          //举报类选
    NSString *remark;        //备注
    NSString *add_time;      //举报时间
}

@property (nonatomic, strong) NSString *report_id;
@property (nonatomic, strong) DynamicRecord *dynamicRecord;
@property (nonatomic, strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *remark;
@property (nonatomic, strong) NSString *add_time;
@end
