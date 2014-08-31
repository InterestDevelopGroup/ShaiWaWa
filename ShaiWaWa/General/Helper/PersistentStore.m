//
//  PersistentStore.m
//  YouLa
//
//  Created by vedon on 9/12/13.
//  Copyright (c) 2013 helloworld. All rights reserved.
//



#import "PersistentStore.h"

#import <objc/runtime.h>
#import <Foundation/Foundation.h>
@implementation PersistentStore
+ (void)createAndSaveWithObject:(Class)objClass params:(NSDictionary *)params
{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(objClass, &outCount);
    id obj = [objClass  MR_createEntity];
    for (int i =0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
        [obj setValue:[params objectForKey:propertyName] forKey:propertyName];
    }
    [[NSManagedObjectContext MR_defaultContext]MR_saveOnlySelfAndWait];
    
}

+ (NSArray *)getObjectWithType:(Class)type Key:(NSString *)key Value:(NSString *)value
{
    NSArray *tempArray = [type MR_findByAttribute:key withValue:value];
    return tempArray;
}


+ (int)countOfObjectWithType:(Class)type
{
    return [type MR_countOfEntities];
}


+ (int)countOfObjectWithType:(Class)type Key:(NSString *)key Value:(NSString *)value
{
    NSArray * result = [[self class] getObjectWithType:type Key:key Value:value];
    return [result count];
}


+ (NSArray *)getAllObjectWithType:(Class)type
{
    NSArray * tempArray = [type MR_findAll];
    return tempArray;
}


+ (id)getLastObjectWithType:(Class)type
{
    NSArray * tempArray = [self getAllObjectWithType:type];
    if ([tempArray count]) {
        id lastObj = [tempArray lastObject];
        return lastObj;
    }else
    {
        return nil;
    }
}


+ (void)updateObject:(id)obj Key:(NSString *)key Value:(NSString *)value
{
    [obj setValue:value forKey:key];
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
}

+ (void)deleteObject:(id)obj
{
    [obj MR_deleteEntity];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
}

+ (void)deleteAllObject:(Class)type
{
    NSArray * arr = [self getAllObjectWithType:type];
    for(id obj in arr)
    {
        [self deleteObject:obj];
    }
}

+ (void)deleteWithType:(Class)type Key:(NSString *)key Value:(NSString *)value
{
    NSArray * arr = [self getObjectWithType:type Key:key Value:value];
    if([arr count] > 0)
    {
        [self deleteObject:arr[0]];
    }

}

+ (void)save
{
    [[NSManagedObjectContext MR_defaultContext] MR_saveOnlySelfAndWait];
}


@end
