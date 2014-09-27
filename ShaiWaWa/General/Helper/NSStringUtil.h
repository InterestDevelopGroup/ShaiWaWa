//
//  NSStringUtil.h
//  ShaiWaWa
//
//  Created by Carl on 14-8-29.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStringUtil : NSObject

+ (NSMutableAttributedString *)makeTopicString:(NSString *)text;
+ (NSArray *)getTopicStringArray:(NSString *)text;
+ (NSArray *)getUserStringRangeArray:(NSString *)text;
@end
