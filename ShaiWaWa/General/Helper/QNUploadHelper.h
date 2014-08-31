//
//  QNUploadHelper.h
//  ShaiWaWa
//
//  Created by Carl on 14-8-20.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSimpleUploader.h"
typedef void (^UploadSuccess)(NSString * str);
typedef void (^UploadFailure)(NSString * str);
@interface QNUploadHelper : NSObject<QiniuUploadDelegate>
@property (nonatomic,strong) QiniuSimpleUploader * qnSimpleUploader;
@property (nonatomic,copy) UploadSuccess uploadSuccess;
@property (nonatomic,copy) UploadFailure uploadFailure;
+ (instancetype)sharedHelper;
- (void)uploadFile:(NSString *)filePath;
- (void)uploadFileData:(NSData *)data withKey:(NSString *)key;
@end
