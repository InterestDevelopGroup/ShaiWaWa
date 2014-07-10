//
//  ControlCenter.h
//  ClairAudient
//
//  Created by Carl on 13-12-31.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "AllModels.h"
@interface ControlCenter : NSObject

+ (AppDelegate *)appDelegate;
+ (UIWindow *)keyWindow;
+ (UIWindow *)newWindow;
+ (void)makeKeyAndVisible;
+ (void)setNavigationTitleWhiteColor;
//push到登陆页面方法
+ (void)pushToLoginVC;
//push到注册页面方法
+ (void)pushToRegisterVC;
//push到提交验证码页面方法
+ (void)pushToPostValidateVC;
//push到完成注册页面方法
+ (void)pushToFinishRegisterVC;
//push到完成重置页面方法
+ (void)pushToFinishResetPwdVC;
//push到添加宝宝页面方法
+ (void)pushToAddBabyVC;
//push到查询好友页面方法
+ (void)pushToSearchFriendVC;
//push到查询好友结果页面
+ (void)pushToSearchRSVC;
//push到用户信息页面
+ (void)pushToUserInfoPageVC;

+ (void)showVC:(NSString *)vcName;
+ (UIViewController *)viewControllerWithName:(NSString *)vcName;
+ (UINavigationController *)navWithRootVC:(UIViewController *)vc;
+ (UINavigationController *)globleNavController;
@end
