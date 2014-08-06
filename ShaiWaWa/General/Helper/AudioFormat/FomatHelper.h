//
//  FomatHelper.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FomatHelper : NSObject

+ (NSString *)amrToWav:(NSString*)filePath;
+ (NSString *)wavToAmr:(NSString*)filePath;
@end
