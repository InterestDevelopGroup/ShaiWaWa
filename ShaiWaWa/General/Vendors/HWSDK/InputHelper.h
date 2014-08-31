//
//  InputHelper.h
//  ZTFinance
//
//  Created by Carl on 14-6-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputHelper : NSObject
+ (NSString *)trim:(NSString *)str;
+ (BOOL)isEmpty:(NSString *)str;
+ (BOOL)isLength:(int)length withString:(NSString *)str;
+ (BOOL)minLength:(int)length withString:(NSString *)str;
+ (BOOL)maxLength:(int)length withString:(NSString *)str;
+ (BOOL)isEmail:(NSString *)str;
+ (BOOL)isPhone:(NSString *)str;
+ (BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression;
@end
