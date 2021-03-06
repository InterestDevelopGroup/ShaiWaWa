//
//  ShareManager.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "HttpService.h"
@interface ShareManager : NSObject

+ (instancetype)sharePlatform;
- (void)configShare;
- (void)shareToWeiXin;
- (void)shareToWeiXinCycle;
- (void)shareToSinaWeiBo;
- (void)shareToQzone;
- (void)shareToWeiXinFriend;
- (void)invitationWeXinFriend:(NSString *)text withURL:(NSString *)url;
- (void)shareWithType:(ShareType)type withContent:(NSString *)content withImage:(UIImage *)image;
- (void)shareWithType:(ShareType)type withContent:(NSString *)content withImagePath:(NSString *)path;

- (void)shareToSinaWeiBoInBackground:(NSString *)text withURL:(NSString *)url;
- (void)shareToQzoneInBackground:(NSString *)text withURL:(NSString *)url;

@end
