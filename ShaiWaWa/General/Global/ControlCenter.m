//
//  ControlCenter.m
//  ClairAudient
//
//  Created by Carl on 13-12-31.
//  Copyright (c) 2013年 helloworld. All rights reserved.
//

#import "ControlCenter.h"

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
    [[self class] setNavigationTitleWhiteColor];
    appDelegate.window = [[self class] newWindow];
    [appDelegate.window makeKeyAndVisible];
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
