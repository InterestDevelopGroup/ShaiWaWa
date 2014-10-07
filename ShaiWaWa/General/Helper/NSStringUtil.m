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


+ (NSString *)calculateTime:(NSString *)timeIntervalStr
{
    if(timeIntervalStr == nil)
    {
        return @"未知";
    }
    
    NSTimeInterval timeInterval = [timeIntervalStr longLongValue];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval delta = currentTime - timeInterval;
    
    NSString * str = @"刚才";
    
    int miniutes = delta/60;
    
    if(miniutes == 0)
    {
        str = @"刚才";
    }
    else if(miniutes < 30)
    {
        str = [NSString stringWithFormat:@"%i分钟前",miniutes];
    }
    else if(miniutes < 60)
    {
        str = @"半小时前";
    }
    else if(miniutes < 120)
    {
        str = @"1小时以前";
    }
    else if(miniutes < 180)
    {
        str = @"2小时以前";
    }
    else
    {
        str = [[NSDate dateWithTimeIntervalSince1970:timeInterval] formatDateString:@"yyyy-MM-dd"];
    }
    
    return str;
}

+ (NSString *)calculateAge:(NSString *)timeIntervalStr
{
    if(timeIntervalStr == nil)
    {
        return @"未知";
    }
    
    NSTimeInterval timeInterval = [timeIntervalStr longLongValue];
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval delta = currentTime - timeInterval;
    //算出多少个月
    float mouths = delta/(60 * 60 * 24 * 30.0);
    NSString * str = @"";
    if(mouths < 12)
    {
        if(mouths < 1.0)
        {
            str = [NSString stringWithFormat:@"%i天",(int)delta/(60 * 60 * 12)];
        }
        else
        {
            str = [NSString stringWithFormat:@"%i个月",(int)mouths];
        }
    }
    else if(mouths == 12)
    {
        str = @"一年";
    }
    else
    {
        int allMouth = ceilf(mouths);
        int year = allMouth/12;
        int mouth = allMouth%12;
        str = [NSString stringWithFormat:@"%i岁%i个月",year,mouth];
    }
    
    return str;
}

#pragma mark -计算某天与宝宝出生那天相差的天数
+ (int)calculateDay:(NSString *)timeIntervalStr
{
    //将生日转换成NSDate对象
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"YY-MM-dd";
    NSDate *birthday = [fmt dateFromString:timeIntervalStr];
    //获取今天的日期
    NSDate *today = [NSDate date];
    return (int)([today timeIntervalSinceDate:birthday] / (60 * 60 * 24));
}

@end
