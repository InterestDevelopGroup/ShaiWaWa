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

-(UserInfo *)userInfo
{
    UserInfo *userInfoDefault;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data = [userDefaults objectForKey:@"userInfomation"];
    userInfoDefault = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return userInfoDefault;
    
}

-(void)setUserInfo:(UserInfo *)userInfo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [userDefaults setObject:data forKey:@"userInfomation"];
    [userDefaults synchronize];
}


-(Setting *)set
{
    Setting * setDefault;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data = [userDefaults objectForKey:@"setInfo"];
    setDefault = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return setDefault;
    
}

-(void)setSet:(Setting *)set
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:set];
    [userDefaults setObject:data forKey:@"setInfo"];
    [userDefaults synchronize];

}

@end
