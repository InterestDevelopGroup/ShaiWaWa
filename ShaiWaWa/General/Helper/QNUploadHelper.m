//
//  QNUploadHelper.m
//  ShaiWaWa
//
//  Created by Carl on 14-8-20.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "QNUploadHelper.h"
#import "AppMacros.h"
#import "GTMBase64.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
@implementation QNUploadHelper

+ (instancetype)sharedHelper
{
    static QNUploadHelper * helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[QNUploadHelper alloc] init];
    });
    
    return helper;
}


- (id)init
{
    if((self = [super init])) {
        NSString * token = [self makeToken];
        _qnSimpleUploader = [QiniuSimpleUploader uploaderWithToken:token];
        _qnSimpleUploader.delegate = self;
    }
    
    return self;
}

- (NSString *)makeToken
{
    int timeInterval = [[[NSDate date] dateByAddingTimeInterval:10 * 3600] timeIntervalSince1970];
    //NSDictionary * dic = @{@"scope":QN_DOMAIN,@"deadline":[NSString stringWithFormat:@"%i",timeInterval],@"returnBody":@"{\"name\": $(fname),\"size\": $(fsize),\"w\": $(imageInfo.width),\"h\": $(imageInfo.height),\"hash\": $(etag)}"};
    NSString * putPolicy = [NSString stringWithFormat:@"{\"scope\":\"%@\",\"deadline\":%i}",QN_DOMAIN,timeInterval];
    //NSLog(@"%@",putPolicy);
    NSString * encodedPutPolocy = [GTMBase64 stringByWebSafeEncodingData:[putPolicy dataUsingEncoding:NSUTF8StringEncoding] padded:YES];
    //NSLog(@"%@",encodedPutPolocy);
    NSString * encodedSign = [self hmacsha1:encodedPutPolocy secret:QN_SECRET_KEY];
    //NSLog(@"%@",encodedSign);
    NSString * token = [NSString stringWithFormat:@"%@:%@:%@",QN_ACEESS_KEY,encodedSign,encodedPutPolocy];
    return token;
    
}

- (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [GTMBase64 stringByWebSafeEncodingData:HMAC padded:YES];
    return hash;
}


- (void)uploadFile:(NSString *)filePath
{
    if(_qnSimpleUploader)
    {
        [_qnSimpleUploader uploadFile:filePath key:[filePath lastPathComponent] extra:nil];
    }
}


- (void)uploadFileData:(NSData *)data withKey:(NSString *)key
{
    if(_qnSimpleUploader)
    {
        [_qnSimpleUploader uploadFileData:data key:key extra:nil];
    }
}

#pragma mark - QiniuUploadDelegate
// Upload progress
- (void)uploadProgressUpdated:(NSString *)theFilePath percent:(float)percent
{
    NSString *progressStr = [NSString stringWithFormat:@"Progress Updated: - %f\n", percent];
    
    NSLog(@"%@",progressStr);
}

- (void)uploadSucceeded:(NSString *)theFilePath ret:(NSDictionary *)ret
{
    NSString *succeedMsg = [NSString stringWithFormat:@"Upload Succeeded: - Ret: %@\n", ret];
    NSLog(@"%@,filePath:%@",succeedMsg,theFilePath);
    if(_uploadSuccess)
    {
        _uploadSuccess(theFilePath);
    }
    
}

// Upload failed
- (void)uploadFailed:(NSString *)theFilePath error:(NSError *)error
{
    NSString *failMsg = [NSString stringWithFormat:@"Upload Failed: %@  - Reason: %@", theFilePath, error];
    NSLog(@"%@",failMsg);
    if(_uploadFailure)
    {
        _uploadFailure(theFilePath);
    }
}
@end
