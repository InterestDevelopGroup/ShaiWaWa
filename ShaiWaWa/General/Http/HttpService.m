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
#import "SVProgressHUD.h"
#import "Setting.h"
#import "Friend.h"


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
        case ShaiWaWa_Num_Existed_Error_Code:
            msg = @"晒娃娃号已经存在.";
            break;
        default:
            msg = @"请求失败.";
            break;
    }
    return msg;
}

- (BOOL)filterError:(NSDictionary *)obj failureBlock:(void (^)(NSError *, NSString *))failure
{
    if(obj == nil || obj[@"err_code"] == nil)
    {
        
        if(failure == NULL)
        {
            return YES;
        }
        
        if([obj[@"err_code"] isKindOfClass:[NSString class]])
        {
            failure(nil,[self getErrorMsgByCode:[obj[@"err_code"] intValue]]);
        }
        else
        {
            failure(nil,[self getErrorMsgByCode:0]);
        }
        return YES;
    }
    
    if(![obj[@"err_code"] isKindOfClass:[NSString class]])
    {
        if(failure){
            failure(nil,[self getErrorMsgByCode:0]);
        }
        return YES;
    }

    if([obj[@"err_code"] intValue] != No_Error_Code)
    {
        if(failure)
        {
            failure(nil,[self getErrorMsgByCode:[obj[@"err_code"] intValue]]);
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
        UserInfo *curUser = [self mapModel:[[obj objectForKey:@"result"] objectAtIndex:0] withClass:[UserInfo class]];
        
        [[UserDefault sharedInstance] setUserInfo:curUser];
        if(success)
        {
            
            success(curUser);
        }
        
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
        
        if(success)
        {
            success(obj);
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
        if (success) {
            success(obj);
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
        if (success) {
            success(obj);
        }
        
        
    } failureBlock:failure];
}


- (void)isExists:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Is_Exists] withParams:params completionBlock:^(id obj) {
        
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
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
        UserInfo *curUser = [[UserInfo alloc] init];
        curUser.phone = [[[UserDefault sharedInstance] userInfo] phone];
        curUser.username = [[[UserDefault sharedInstance] userInfo] username];
        curUser.password = [params objectForKey:@"password"];
        curUser.uid = [[[UserDefault sharedInstance] userInfo] uid];
        curUser.sex = [[[UserDefault sharedInstance] userInfo] sex];
        curUser.sww_number = [[[UserDefault sharedInstance] userInfo] sww_number];
        curUser.avatar = [[[UserDefault sharedInstance] userInfo] avatar];
        
        [[UserDefault sharedInstance] setUserInfo:curUser];
        if(success)
        {
            
            success(curUser);
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

        UserInfo *curUser = [self mapModel:[[obj objectForKey:@"result"] objectAtIndex:0] withClass:[UserInfo class]];
        NSLog(@"%@",curUser.avatar);
        [[UserDefault sharedInstance] setUserInfo:curUser];
        
        if(success)
        {
            
            success(curUser);
        }
    } failureBlock:failure];
}


/**
 @desc 获取系统短消息
 */
//TODO:获取系统短消息
- (void)getSystemNotification:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
    [self postJSON:[self mergeURL:Get_System_Notification] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
//            if ([[obj objectForKey:@"result"] count] > 0) {
//                success([obj objectForKey:@"result"]);
//            }
//            else
//                success([[obj objectForKey:@"result"] objectAtIndexPath:0]);
        }
    } failureBlock:failure];
}

/**
 @desc 更新系统短消息
 */
//TODO:更新系统短消息
- (void)updateSystemNotification:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Update_System_Notification] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
    } failureBlock:failure];
}

/**
 @desc 添加宝宝
 */
//TODO:添加宝宝
- (void)addBaby:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Add_Baby] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 获取宝宝列表
 */
//TODO:获取宝宝列表
- (void)getBabyList:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Baby_List] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
                     }
//            if (![obj isEqual:[NSNull null]]) {
//                if ([[obj objectForKey:@"result"] count] > 1) {
//                    success([obj objectForKey:@"result"]);
//                }
//                else
//                    success([[obj objectForKey:@"result"] objectAtIndexPath:0]);
//            }
//            else
//            {
//                success(obj);
//            }
//        }
    } failureBlock:failure];
}

/**
 @desc 获取宝宝信息
 */
//TODO:获取宝宝信息
- (void)getBabyInfo:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Baby_Info] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}


/**
 @desc 添加宝宝成长记录
 */
//TODO:添加宝宝成长记录
- (void)addBabyGrowRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Add_Baby_Grow_Record] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}


/**
 @desc 获取宝宝成长记录
 */
//TODO:获取宝宝成长记录
- (void)getBabyGrowRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Baby_Grow_Record] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 更新宝宝信息
 */
//TODO:更新宝宝信息
- (void)updateBabyInfo:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Update_Baby_Info] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 发布动态
 */
//TODO:发布动态
- (void)publishRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Publish_Record] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 删除动态
 */
//TODO 删除动态
- (void)deleteRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Delete_Record] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 更新赞状态
 */
//TODO:更新赞状态
- (void)updatePraiseStatus:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Update_Praise_Status] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 动态取消赞
 */
//TODO:动态取消赞
- (void)cancelLike:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Cancel_Like] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 动态添加赞
 */
//TODO:动态添加赞
- (void)addLike:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Add_Like] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 获取动态被赞用户列表
 */
//TODO:获取动态被赞用户列表

- (void)getLikingList:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Likes_List] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 添加评论
 */
//TODO:添加评论
- (void)addComment:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Add_Comment] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 添加收藏
 */
//TODO:添加收藏
- (void)addFavorite:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Add_Favorite] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];

}

/**
 @desc 获取收藏列表
 */
//TODO:获取收藏列表
- (void)getFavorite:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Favorite_List] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 获取动态列表
 */
//TODO 获取动态列表
- (void)getRecordList:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Record_List] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}


/**
 @desc 根据用户id获取宝宝动态接口
 */
//TODO:根据用户id获取宝宝动态接口
- (void)getRecordByUserID:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Record_By_User_ID] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
     
                success(obj);
            
        }
    } failureBlock:failure];
}


/**
 @desc 获取好友宝宝动态
 */
//TODO: 获取好友宝宝动态
- (void)getRecordByFriend:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Record_By_Friend] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}


/**
 @desc 获取特别关注宝宝动态接口
 */
//TODO:获取特别关注宝宝动态接口
- (void)getRecordByFollow:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Recrod_By_Follow] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
//            if ([[obj objectForKey:@"result"] count] > 0) {
//                success([obj objectForKey:@"result"]);
//            }
//            else
//                success([[obj objectForKey:@"result"] objectAtIndexPath:0]);
        }
    } failureBlock:failure];
}

/**
 @desc 根据话题获取宝宝动态接口
 */
//TODO:根据话题获取宝宝动态接口
- (void)getRecordByTopic:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Recrod_By_Follow] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        
        if (success) {
            if ([[obj objectForKey:@"result"] count] > 0) {
                success([obj objectForKey:@"result"]);
            }
            else
                success([[obj objectForKey:@"result"] objectAtIndexPath:0]);
        }
    } failureBlock:failure];
}


/**
 @desc 搜索动态接口
 */
//TODO:搜索动态接口
- (void)searchRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Search_Recrod] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
//            if ([[obj objectForKey:@"result"] count] > 0) {
//                success([obj objectForKey:@"result"]);
//            }
//            else
//                success([[obj objectForKey:@"result"] objectAtIndexPath:0]);
        }
    } failureBlock:failure];
}

/**
 @desc 申请好友
 */
//TODO:申请好友
- (void)applyFriend:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Apply_Friend] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 通过好友
 */
//TODO:通过好友
- (void)passFriend:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Pass_Friend] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 获取好友列表
 */
//TODO:获取好友列表
- (void)getFriendList:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Friend_List] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
//        Friend *friend = [self mapModel:[[obj objectForKey:@"result"] objectAtIndex:0] withClass:[Friend class]];
        
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 删除好友
 */
//TODO:删除好友
- (void)deleteFriend:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Delete_Friend] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 搜索好友
 */
//TODO:搜索好友
- (void)searchFriend:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Search_Friend] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
    } failureBlock:failure];
}

/**
 @desc 获取新浪好友
 */
//TODO:获取新浪好友
- (void)getSinaFriend:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Sina_Friend] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
    } failureBlock:failure];
}

/**
 @desc 获取QQ好友
 */
//TODO:获取QQ好友
- (void)getQQFriend:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_QQ_Friend] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
    } failureBlock:failure];
}

/**
 @desc 获取通讯录好友
 */
//TODO:获取通讯录好友
- (void)getAddressBookFriend:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Addressbook_Friend] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
    } failureBlock:failure];
}

/**
 @desc 根据用户id获取用户信息接口
 */
//TODO:根据用户id获取用户信息接口
- (void)getUserInfo:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_User_Info] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
//        UserInfo *user = [self mapModel:[[obj objectForKey:@"result"] objectAtIndexPath:0] withClass:[UserInfo class]];
        if (success) {
            success(obj);
        }
        
    } failureBlock:failure];
}

/**
 @desc 特别关注宝宝接口
 */
//TODO:特别关注宝宝接口
- (void)followBaby:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Follow_Baby] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 获取宝宝备注
 */
//TODO:获取宝宝备注
- (void)getBabyRemark:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Baby_Remark] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 添加宝宝备注
 */
//TODO:添加宝宝备注
- (void)addBabyRemark:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Add_Baby_Remark] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 更新宝宝备注
 */
//TODO:更新宝宝备注
- (void)updateBabyRemark:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Update_Baby_Remark] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 删除宝宝备注
 */
//TODO:删除宝宝备注
- (void)deleteBabyRemark:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Delete_Baby_Remark] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}

/**
 @desc 添加意见反馈
 */
//TODO:添加意见反馈
- (void)addFeedback:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Add_Feedback] withParams:params completionBlock:^(id obj) {
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
    } failureBlock:failure];
}



/**
 @desc 获取用户设置
 */
//TODO:获取用户设置

- (void)getUserSetting:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    
    [self postJSON:[self mergeURL:Get_User_Setting] withParams:params completionBlock:^(id obj) {
        
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
  
//        NSLog(@"%@",[obj objectForKey:@"id"]);
//        Setting *user_set = [self mapModel:[obj objectForKey:@"result"] withClass:[Setting class]];
        
        Setting *user_set = [[Setting alloc] init];
        user_set.set_id = [[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"id"];
        user_set.userInfo.uid = [[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"uid"];
        user_set.is_remind = [[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"is_remind"];
        user_set.visibility = [[[obj objectForKey:@"result"] objectAtIndex:0]objectForKey:@"visibility"];
        user_set.show_position = [[[obj objectForKey:@"result"] objectAtIndex:0]objectForKey:@"show_position"];
        user_set.is_share = [[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"is_share"];
        user_set.upload_video_only_wifi = [[[obj objectForKey:@"result"] objectAtIndex:0]objectForKey:@"upload_video_only_wifi"];
        user_set.upload_audio_only_wifi = [[[obj objectForKey:@"result"] objectAtIndex:0]objectForKey:@"upload_audio_only_wifi"];
        user_set.upload_image_only_wifi = [[[obj objectForKey:@"result"] objectAtIndex:0]objectForKey:@"upload_image_only_wifi"];
        
        [[UserDefault sharedInstance] setSet:user_set];
        if(success)
        {
            
            success(user_set);
        }
    } failureBlock:failure];
}



/**
 @desc 更新用户设置
 */
//TODO:更新用户设置

- (void)updateUserSetting:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Update_User_Setting] withParams:params completionBlock:^(id obj) {
        
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
        
    } failureBlock:failure];
}

/**
 @desc 获取全部动态
 */
//TODO:获取全部动态

- (void)getRecrodList:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure
{
    [self postJSON:[self mergeURL:Get_Record_List] withParams:params completionBlock:^(id obj) {
        
        BOOL isError = [self filterError:obj failureBlock:failure];
        if (isError) {
            return ;
        }
        if (success) {
            success(obj);
        }
        
    } failureBlock:failure];

}

@end
