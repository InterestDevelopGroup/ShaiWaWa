//
//  Topic.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DynamicRecord;
@interface Topic : NSObject<NSCopying, NSCoding> 
{
    NSString *tid;                  //话题id
    DynamicRecord *dynameicRecord;
    NSString *topicContent;         //话题内容
}

@property (nonatomic, strong) NSString *tid;
@property (nonatomic, strong) DynamicRecord *dynamicRecord;
@property (nonatomic, strong) NSString *topicContent;
@end
