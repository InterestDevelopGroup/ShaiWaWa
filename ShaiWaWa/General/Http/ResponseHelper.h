//
//  ResponseHelper.h
//  ShaiWaWa
//
//  Created by Carl on 14-8-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AllModels.h"
@interface ResponseHelper : NSObject

+ (NSArray *)transformToBabyRecords:(NSArray *)arr;
+ (NSArray *)transformToRecordComments:(NSArray *)arr;
+ (NSArray *)transformToMessages:(NSArray *)arr;
@end
