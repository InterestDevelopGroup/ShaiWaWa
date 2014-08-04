//
//  RecordVideo.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DynamicRecord;
@interface RecordVideo : NSObject<NSCopying, NSCoding> 
{
    NSString *video_id;             //视频id
    DynamicRecord *dynamicRecord;
    NSString *video;                //视频
}

@property (nonatomic, strong) NSString *video_id;
@property (nonatomic, strong) DynamicRecord *dynamicRecord;
@property (nonatomic, strong) NSString *video;
@end
