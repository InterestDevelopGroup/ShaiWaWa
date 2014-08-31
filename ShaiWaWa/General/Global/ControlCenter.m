//
//  ControlCenter.m
//  ClairAudient
//
//  Created by Carl on 13-12-31.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "ControlCenter.h"
#import "UserDefault.h"
#import "UserInfo.h"

@implementation ControlCenter

+ (AppDelegate *)appDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+ (UIWindow *)keyWindow
{
    return [[UIApplication sharedApplication] keyWindow];
}

+ (UIWindow *)newWindow
{
    UIWindow * window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.backgroundColor = [UIColor whiteColor];
    return window;
}

+ (void)makeKeyAndVisible
{
    
    AppDelegate * appDelegate = [[self class] appDelegate];
    appDelegate.window = [[self class] newWindow];
    UINavigationController * nav;
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    if(users == nil)
    {
        nav = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"LoginViewController"]];
    }
    else
    {
        nav = [[self class] navWithRootVC:[[self class] viewControllerWithName:@"ChooseModeViewController"]];
    }
    appDelegate.navigationController = nav;
    appDelegate.window.rootViewController = appDelegate.navigationController;
    [appDelegate.window makeKeyAndVisible];
    nav = nil;
}


+ (void)setNavigationTitleWhiteColor
{
    [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]}];
}

+ (void)pushToLoginVC
{
    [[self class] showVC:@"LoginViewController"];
}

+ (void)pushToRegisterVC
{
    [[self class] showVC:@"RegisterViewController"];
}

+ (void)pushToPostValidateVC
{
    [[self class] showVC:@"PostValidateViewController"];
}

+ (void)pushToFinishRegisterVC
{
    [[self class] showVC:@"FinishRegisterViewController"];
}

+ (void)pushToFinishResetPwdVC
{
     [[self class] showVC:@"ResetPwdNextStepViewController"];
}

+ (void)pushToAddBabyVC
{
    [[self class] showVC:@"AddBabyInfoViewController"];
}
+ (void)pushToSearchFriendVC
{
    [[self class] showVC:@"SearchGoodFriendsViewController"];
}
+ (void)pushToSearchRSVC
{
    [[self class] showVC:@"SearchRSViewController"];
}
+ (void)pushToUserInfoPageVC
{
    [[self class] showVC:@"UserInfoPageViewController"];
}
+ (void)pushToMyCollectionVC
{
    [[self class] showVC:@"MyCollectionViewController"];
}

+ (void)showVC:(NSString *)vcName
{
    UIViewController * vc = [[self class] viewControllerWithName:vcName];
    AppDelegate * appDelegate = [[self class] appDelegate];
    [appDelegate.navigationController pushViewController:vc animated:YES];
    vc = nil;
}


+ (UIViewController *)viewControllerWithName:(NSString *)vcName
{
    Class cls = NSClassFromString(vcName);
    UIViewController * vc = [[cls alloc] initWithNibName:vcName bundle:[NSBundle mainBundle]];
    return vc;
}

+ (UINavigationController *)navWithRootVC:(UIViewController *)vc
{
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    return nav;
}

+(UINavigationController *)globleNavController
{
    static UINavigationController * nav  = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nav = [[UINavigationController alloc]init];
    });
    return nav;
}
@end
