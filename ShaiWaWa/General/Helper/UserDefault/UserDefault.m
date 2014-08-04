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
    
//    Student *stu1 = [[Student alloc]initWithName:@"124" and:@"111"];//学生对象stu1
//    Student *stu2 = [[Student alloc]initWithName:@"223" and:@"222"];//学生对象stu2
//    NSArray *stuArray =[NSArray arrayWithObjects:stu1,stu2, nil];//学生对象数组，里面包含stu1和stu2
//    
//    NSData *stuData = [NSKeyedArchiver archivedDataWithRootObject:stuArray];//归档
//    NSLog(@"data = %@",stuData);
//    NSArray *stuArray2 =[NSKeyedUnarchiver unarchiveObjectWithData:stuData];//逆归档
//    NSLog(@"array2 = %@",stuArray2);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [userDefaults setObject:data forKey:@"userInfomation"];
    [userDefaults synchronize];
    
    //[userDefaults setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"userInfomation"];
//    [userDefaults setValue:[NSString stringWithFormat:@"%@",userInfo] forKey:@"userInfomation"];

    
}

-(Setting *)set
{
    Setting *setDefault;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data = [userDefaults objectForKey:@"setInfo"];
    setDefault = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return setDefault;
    
}

-(void)setSet:(Setting *)set
{
    
    //    Student *stu1 = [[Student alloc]initWithName:@"124" and:@"111"];//学生对象stu1
    //    Student *stu2 = [[Student alloc]initWithName:@"223" and:@"222"];//学生对象stu2
    //    NSArray *stuArray =[NSArray arrayWithObjects:stu1,stu2, nil];//学生对象数组，里面包含stu1和stu2
    //
    //    NSData *stuData = [NSKeyedArchiver archivedDataWithRootObject:stuArray];//归档
    //    NSLog(@"data = %@",stuData);
    //    NSArray *stuArray2 =[NSKeyedUnarchiver unarchiveObjectWithData:stuData];//逆归档
    //    NSLog(@"array2 = %@",stuArray2);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:set];
    [userDefaults setObject:data forKey:@"setInfo"];
    [userDefaults synchronize];
    
    //[userDefaults setObject:[NSString stringWithFormat:@"%@",userInfo] forKey:@"userInfomation"];
    //    [userDefaults setValue:[NSString stringWithFormat:@"%@",userInfo] forKey:@"userInfomation"];
    
    
}

@end
