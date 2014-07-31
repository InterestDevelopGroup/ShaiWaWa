//
//  HttpService.m
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "HttpService.h"
#import "AllModels.h"
#import <objc/runtime.h>
#define HW @"hw_"       //关键字属性前缀
#define Public_Key  @"5df39a7723b31e8abc5a826d"
#define Private_Key @"1ee947ee71d3f4d214796750"

#import "UserInfo.h"
#import "UserDefault.h"
@implementation HttpService

#pragma mark Life Cycle
- (id)init
{
    if ((self = [super init])) {
        
    }
    return  self;
}

#pragma mark Class Method
+ (HttpService *)sharedInstance
{
    static HttpService * this = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        this = [[self alloc] init];
    });
    return this;
}

#pragma mark Private Methods
- (NSString *)mergeURL:(NSString *)methodName
{
    NSString * str =[NSString stringWithFormat:@"%@%@",URL_PREFIX,methodName];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return str;
}

/**
 @desc 返回类的属性列表
 @param 类对应的class
 @return NSArray 属性列表
 */
+ (NSArray *)propertiesName:(Class)cls
{
    if(cls == nil) return nil;
    unsigned int outCount,i;
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    NSMutableArray * list = [NSMutableArray arrayWithCapacity:outCount];
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(property)];
        if(propertyName && [propertyName length] != 0)
        {
            [list addObject:propertyName];
        }
    }
    return list;
}



//将取得的内容转换为模型
- (NSArray *)mapModelsProcess:(id)responseObject withClass:(Class)class
{
    //判断返回值
    if(!responseObject || [responseObject isKindOfClass:[NSNull class]] || ![responseObject isKindOfClass:[NSArray class]])
    {
        return nil;
    }
    
//    NSArray * properties = [[self class] propertiesName:class];
    NSMutableArray * models = [NSMutableArray array];
    for (NSDictionary * info in responseObject) {
        if (info) {
            id model = [self mapModel:info withClass:class];
            if(model)
            {
                [models addObject:model];
            }
        }
        
    }
    
    return (NSArray *)models;
}

- (id)mapModel:(id)reponseObject withClass:(Class)cls
{
    if (!reponseObject || [reponseObject isKindOfClass:[NSNull class]]) {
        return nil;
    }
    id model  = [[cls alloc] init];
    NSArray * properties = [[self class] propertiesName:cls];
    for(NSString * property in properties)
    {
        NSString * tmp = [property stringByReplacingOccurrencesOfString:HW withString:@""];
        id value = [reponseObject valueForKey:tmp];
        if(![value isKindOfClass:[NSNull class]])
        {
            if(![value isKindOfClass:[NSString class]])
            {
                [model setValue:[value stringValue] forKey:property];
            }
            else
            {
                [model setValue:value forKey:property];
            }
        }
    }
    return model;
}

- (NSDictionary *)makeAuth
{
    long timeInterval = (long)[[NSDate date] timeIntervalSince1970];
    NSString * tmp = [NSString stringWithFormat:@"%@%ld%@",Public_Key,timeInterval,Private_Key];
    NSString * signature = [tmp md5];
    return @{@"signature":signature,@"publicKey":Public_Key,@"timeStamp":[NSString stringWithFormat:@"%ld",timeInterval]};
}

- (NSString *)getErrorMsgByCode:(int)code
{
    NSString * msg = @"";
    switch (code) {
        case No_Error_Code:
            msg = @"成功";
            break;
        case Unknow_Error_Code:
            msg = @"未知错误.";
            break;
        case Name_Or_Pass_Error_Code:
            msg = @"用户名或密码错误.";
            break;
        case Validate_Error_Code:
            msg = @"验证码错误";
            break;
        case Phone_Existed_Error_Code:
            msg = @"手机号码已经存在.";
            break;
        case Param_Invalid_Error_Code:
            msg = @"参数无效.";
            break;
        case Illegal_Request_Error_Code:
            msg = @"非法请求.";
            break;
        case Username_Existed_Error_Code:
            msg = @"用户名已经存在.";
            break;
        default:
            msg = @"请求失败.";
            break;
    }
    return msg;
}

- (BOOL)filterError:(NSDictionary *)obj failureBlock:(void (^)(NSError *, NSString *))failure
{
    if(obj == nil || obj[@"err_code"])
    {
        if(failure && [obj[@"err_code"] isKindOfClass:[NSString class]])
        {
            failure(nil,[self getErrorMsgByCode:[obj[@"err_code"] intValue]]);
        }
        else
        {
            failure(nil,[self getErrorMsgByCode:0]);
        }
        return YES;
    }
    return NO;
}

#pragma mark Instance Method
/**
 @desc 继承父类方法
 */
- (void)postJSON:(NSString *)url withParams:(NSDictionary *)params completionBlock:(void (^)(id))success failureBlock:(void (^)(NSError *, NSString *))failure
{
    NSMutableDictionary * dic = [@{} mutableCopy];
    if(params)
    {
        for(NSString * key in [params allKeys])
        {
            [dic setObject:params[key] forKey:key];
        }
    }
    
    NSDictionary * auth = [self makeAuth];
    for (NSString * key in [auth allKeys])
    {
        [dic setObject:auth[key] forKey:key];
    }
    //DDLogVerbose(@"%@",dic);
    [super postJSON:url withParams:dic completionBlock:success failureBlock:false];
}

/**
 @desc 用户登录
 */
//TODO:用户登录
- (void)userLogin:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:User_Login] withParams:params completionBlock:^(id obj) {
        
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
       
        UserInfo *curUser = [[UserInfo alloc] init];
        curUser.username = [[obj objectForKey:@"result"] objectForKey:@"phone"];
        curUser.password = [[obj objectForKey:@"result"] objectForKey:@"password"];
        
        [[UserDefault sharedInstance] setUserInfo:curUser];
        if(success)
        {
            success(curUser);
        }
         // NSLog(@"%@",[[obj objectForKey:@"result"] objectForKey:@"username"]);
    } failureBlock:failure];
}

/**
 @desc 用户注册
 */
//TODO:用户注册
- (void)userRegister:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * reponseString))failure
{
    [self postJSON:[self mergeURL:User_Register] withParams:params completionBlock:^(id obj) {
        
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        
        UserInfo * userInfo = [[UserInfo alloc] init];
        userInfo.uid = [[obj objectForKey:@"result"] objectForKey:@"id"];
        userInfo.username = [[obj objectForKey:@"result"] objectForKey:@"username"];
        
        if(success)
        {
            success(userInfo);
        }
        // NSLog(@"%@",[[obj objectForKey:@"result"] objectForKey:@"username"]);
    } failureBlock:failure];
}


/**
 @desc 第三方登陆
 */
//TODO:第三方登陆
- (void)openLogin:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Open_Login] withParams:params completionBlock:^(id obj) {
        
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        
    } failureBlock:failure];
}

/**
 @desc 发送验证码
 */
//TODO:发送验证码
- (void)sendValidateCode:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:ValidateCode] withParams:params completionBlock:^(id obj) {
        
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        
        
        
    } failureBlock:failure];
}

/**
 @desc 修改密码
 */
//TODO:修改密码
- (void)changePassword:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Change_Password] withParams:params completionBlock:^(id obj) {
        
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        
    } failureBlock:failure];

}

/**
 @desc 更新用户信息
 */
//TODO:更新用户信息
- (void)updateUserInfo:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Update_User_Info] withParams:params completionBlock:^(id obj) {
        
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        
    } failureBlock:failure];
}


/**
 @desc 获取系统短消息
 */
//TODO:获取系统短消息
- (void)getSystemNotification:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}

/**
 @desc 更新系统短消息
 */
//TODO:更新系统短消息
- (void)updateSystemNotification:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}

/**
 @desc 添加宝宝
 */
//TODO:添加宝宝
- (void)addBaby:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}

/**
 @desc 获取宝宝列表
 */
//TODO:获取宝宝列表
- (void)getBabyList:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}

/**
 @desc 获取宝宝信息
 */
//TODO:获取宝宝信息
- (void)getBabyInfo:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}


/**
 @desc 添加宝宝成长记录
 */
//TODO:添加宝宝成长记录
- (void)addBabyGrowRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}


/**
 @desc 获取宝宝成长记录
 */
//TODO:获取宝宝成长记录
- (void)getBabyGrowRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}

/**
 @desc 更新宝宝信息
 */
//TODO:更新宝宝信息
- (void)updateBabyInfo:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}

/**
 @desc 发布动态
 */
//TODO:发布动态
- (void)publishRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}

/**
 @desc 更新赞状态
 */
//TODO:更新赞状态
- (void)updatePraiseStatus:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}

/**
 @desc 添加评论
 */
//TODO:添加评论
- (void)addComment:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
}

@end
