//
//  UserDefault.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-22.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UserDefault.h"


@implementation UserDefault

+(UserDefault *) sharedInstance{
    static UserDefault * userDef = nil ;
    @synchronized(self){
        if(userDef == nil){
            userDef = [[self alloc] init];
            
        }
    }
    
    return userDef ;
}
@end
