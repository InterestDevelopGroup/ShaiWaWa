//
//  RecordAudio.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DynamicRecord;
@interface RecordAudio : NSObject<NSCopying, NSCoding> 
{
    NSString *audio_id;             //音频id
    DynamicRecord *dynamicRecord;
    NSString *audio;                //音频
}

@property (nonatomic, strong) NSString *audio_id;
@property (nonatomic, strong) DynamicRecord *dynamicRecord;
@property (nonatomic, strong) NSString *audio;
@end
