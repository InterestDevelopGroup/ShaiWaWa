//
//  ShareManager.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject

+ (instancetype)sharePlatform;
- (void)configShare;
- (void)shareToWeiXin;
- (void)shareToWeiXinCycle;
- (void)shareToSinaWeiBo;
- (void)shareToQzone;

@end
