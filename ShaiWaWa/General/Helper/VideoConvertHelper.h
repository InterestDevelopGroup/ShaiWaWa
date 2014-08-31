//
//  VideoConvertHelper.h
//  ShaiWaWa
//
//  Created by Carl on 14-8-22.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^FinishBlcok)(void);
typedef void (^FailureBlock)(void);
typedef void (^CancelBlock)(void);
@interface VideoConvertHelper : NSObject
@property (nonatomic,copy) FinishBlcok finishBlock;
@property (nonatomic,copy) FailureBlock failureBlock;
@property (nonatomic,copy) CancelBlock cancelBlock;
+ (instancetype)sharedHelper;
- (void)convertMov:(NSString *)movPath toMP4:(NSString *)mp4Path;
- (UIImage *)getVideoThumb:(NSString *)path;
- (UIImage *)getVideoFirstFrame:(NSString *)path;
@end
