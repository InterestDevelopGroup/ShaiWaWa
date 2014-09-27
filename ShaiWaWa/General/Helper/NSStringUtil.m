//
//  NSStringUtil.m
//  ShaiWaWa
//
//  Created by Carl on 14-8-29.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "NSStringUtil.h"

@implementation NSStringUtil


+ (NSMutableAttributedString *)makeTopicString:(NSString *)text
{
    
    if(text == nil)
    {
        return [[NSMutableAttributedString alloc] init];
    }
    NSString * regex = @"#([^\\#|.]+)#";
    NSRegularExpression * regularExpress = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * arr = [regularExpress matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    
    
    NSMutableAttributedString * attrContent = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor]}];
    for(NSTextCheckingResult * result in arr)
    {
        //DDLogInfo(@"%@",[text substringWithRange:result.range]);
        [attrContent addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:131.0/255.0f green:169.0/255.0f blue:88.0/255.0f alpha:1.0] range:result.range];
    }
    
    
    regex = @"@[\\u4e00-\\u9fa5\\w\\-]+";
    regularExpress = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    arr = [regularExpress matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    for(NSTextCheckingResult * result in arr)
    {
        [attrContent addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:131.0/255.0f green:169.0/255.0f blue:88.0/255.0f alpha:1.0]  range:result.range];
    }
    
    return attrContent;
}

+ (NSArray *)getTopicStringArray:(NSString *)text
{
    if(text == nil)
    {
        return @[];
    }
    
    NSString * regex = @"#([^\\#|.]+)#";
    NSRegularExpression * regularExpress = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * results = [regularExpress matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    NSMutableArray * arr = [@[] mutableCopy];
    for(NSTextCheckingResult * result in results)
    {
        [arr addObject:[text substringWithRange:result.range]];
    }
    
    return (NSArray *)arr;
}

+ (NSArray *)getUserStringRangeArray:(NSString *)text
{
    if(text == nil)
    {
        return @[];
    }

    NSString * regex = @"@[\\u4e00-\\u9fa5\\w\\-]+";
    NSRegularExpression * regularExpress = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray * results = [regularExpress matchesInString:text options:0 range:NSMakeRange(0, [text length])];
    NSMutableArray * arr = [@[] mutableCopy];
    for(NSTextCheckingResult * result in results)
    {
        //[arr addObject:[text substringWithRange:result.range]];
        [arr addObject:NSStringFromRange(result.range)];
    }
    
    return (NSArray *)arr;
}

@end
