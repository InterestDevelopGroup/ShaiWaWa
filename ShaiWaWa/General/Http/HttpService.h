//
//  HttpService.h
//  HWSDK
//
//  Created by Carl on 13-11-28.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "AFHttp.h"
#define URL_PREFIX @"https://115.29.248.57/api/"
#define User_Login                                  @"login"
#define User_Register                               @"register"
#define Open_Login                                  @"open_login"
#define ValidateCode                                @"validatecode"
#define Change_Password                             @"change_password"
#define Update_User_Info                            @"Update_User"
#define Get_System_Notification                     @"get_system_notification"
#define Update_System_Notification                  @"update_system_notification"
#define Add_Baby                                    @"add_baby"
#define Get_Baby_List                               @"get_baby_list"
#define Get_Baby_Info                               @"get_baby_info"
#define Add_Baby_Grow_Record                        @"add_baby_grow_record"
#define Get_Baby_Grow_Record                        @"get_baby_grow_record"
#define Update_Baby_Info                            @"Update_Baby_Info"
#define Publish_Record                              @"Publish_Record"
#define Update_Praise_Status                        @"update_praise_status"
#define Add_Comment                                 @"add_comment"
#define Add_Favorite                                @"add_favorite"
#define Delete_Record                               @"Delete_Record"
#define Get_Record_List                             @"get_record_list"
#define Get_Baby_Record_List                        @"get_baby_record_list"
#define Get_Record_By_Friend                        @"get_record_by_friend"
#define Get_Recrod_By_Follow                        @"get_record_by_follow"
#define Search_Recrod                               @"search_record"
#define Get_Record_By_Topic                         @"get_record_by_topic"
#define Get_Favorite_List                           @"get_favorite_list"
#define Apply_Friend                                @"apply_friend"
#define Pass_Friend                                 @"pass_friend"
#define Get_Friend_List                             @"Get_Friend_List"
#define Delete_Friend                               @"Delete_Friend"
#define Search_Friend                               @"search_friend"
#define Get_Sina_Friend                             @"get_sina_friend"
#define Get_QQ_Friend                               @"get_qq_friend"
#define Get_Addressbook_Friend                      @"get_addressbook_friend"
#define Get_User_Info                               @"Get_User_Info"
#define Follow_Baby                                 @"follow"
#define Get_User_Setting                            @"get_user_setting"
#define Add_Feedback                                @"add_feedback"
#define Update_User_Setting                         @"update_user_setting"
typedef enum {
    No_Error_Code = 10000,
    Unknow_Error_Code,
    Name_Or_Pass_Error_Code,
    Validate_Error_Code,
    Phone_Existed_Error_Code,
    Param_Invalid_Error_Code,
    Illegal_Request_Error_Code,
    Username_Existed_Error_Code
}API_Error_Code;

@interface HttpService : AFHttp

+ (HttpService *)sharedInstance;


/**
 @desc 用户登录
 */
//TODO:用户登录
- (void)userLogin:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;
/**
 @desc 用户注册
 */
//TODO:用户注册
- (void)userRegister:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 第三方登陆
 */
//TODO:第三方登陆
- (void)openLogin:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 修改密码
 */
//TODO:修改密码
- (void)changePassword:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 更新用户信息
 */
//TODO:更新用户信息
- (void)updateUserInfo:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 获取系统短消息
 */
//TODO:获取系统短消息
- (void)getSystemNotification:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 更新系统短消息
 */
//TODO:更新系统短消息
- (void)updateSystemNotification:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 添加宝宝
 */
//TODO:添加宝宝
- (void)addBaby:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取宝宝列表
 */
//TODO:获取宝宝列表
- (void)getBabyList:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 获取宝宝信息
 */
//TODO:获取宝宝信息
- (void)getBabyInfo:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 添加宝宝成长记录
 */
//TODO:添加宝宝成长记录
- (void)addBabyGrowRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 获取宝宝成长记录
 */
//TODO:获取宝宝成长记录
- (void)getBabyGrowRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 更新宝宝信息
 */
//TODO:更新宝宝信息
- (void)updateBabyInfo:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 发布动态
 */
//TODO:发布动态
- (void)publishRecord:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 更新赞状态
 */
//TODO:更新赞状态
- (void)updatePraiseStatus:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 添加评论
 */
//TODO:添加评论
- (void)addComment:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;
/**
 @desc 获取用户设置
 */
//TODO:获取用户设置

- (void)getUserSetting:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;
/**
 @desc 意见反馈
 */
//TODO:意见反馈

- (void)feedBack:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

/**
 @desc 更新用户设置
 */
//TODO:更新用户设置

- (void)updateUserSetting:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;



/**
 @desc 获取全部动态
 */
//TODO:获取全部动态

- (void)getRecrodList:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;




/**
 @desc 获取特别关注宝宝动态
 */
//TODO:获取特别关注宝宝动态

- (void)getRecrodByFollow:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;


/**
 @desc 根据关键字搜索宝宝动态
 */
//TODO:根据关键字搜索宝宝动态

- (void)searchRecrod:(NSDictionary *)params completionBlock:(void (^)(id object))success failureBlock:(void (^)(NSError * error,NSString * responseString))failure;

@end
