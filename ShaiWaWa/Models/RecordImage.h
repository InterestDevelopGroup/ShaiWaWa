//
//  RecordImage.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DynamicRecord;
@interface RecordImage : NSObject<NSCopying, NSCoding> 
{
    NSString *image_id;             //图片id
    DynamicRecord *dynamicRecord;
    NSString *image;                //图片
}

@property (nonatomic, strong) NSString *image_id;
@property (nonatomic, strong) DynamicRecord *dynamicRecord;
@property (nonatomic, strong) NSString *image;

@end
