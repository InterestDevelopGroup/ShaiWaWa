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
+ (void)pushToLoginVC;
+ (void)showVC:(NSString *)vcName;
+ (UIViewController *)viewControllerWithName:(NSString *)vcName;
+ (UINavigationController *)navWithRootVC:(UIViewController *)vc;
+ (UINavigationController *)globleNavController;
@end
