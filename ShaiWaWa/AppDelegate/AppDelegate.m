//
//  AppDelegate.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AppDelegate.h"
#import "ControlCenter.h"
#import "ShareManager.h"
#import "HttpService.h"
#import "AppMacros.h"
#import "PersistentStore.h"
#import "Topic.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import <ShareSDK/ShareSDK.h>
@implementation AppDelegate
@synthesize postValidateType= _postValidateType;
@synthesize postValidatePhoneNum = _postValidatePhoneNum;
@synthesize postValidateCore = _postValidateCore;
@synthesize postValidateCoreTime = _postValidateCoreTime;
@synthesize deleteDyId = _deleteDyId;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"ShaiWaWa"];
    [IO createDirectoryInDocument:Avatar_Folder];
    [IO createDirectoryInDocument:Publish_Image_Folder];
    [IO createDirectoryInDocument:Publish_Video_Folder];
    [IO createDirectoryInDocument:Publish_Audio_Folder];
    [[ShareManager sharePlatform] configShare];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [ControlCenter makeKeyAndVisible];
    [self customUI];
    [self firstLaunch];
    [self fetchConfig];
    return YES;
}

//添加的
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:nil];
}
 
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
    
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Private Methods
- (void)customUI
    {
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"square_biaotilan"] forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor]}];
#ifdef iOS7_SDK
        if([OSHelper iOS7])
        {
            //[[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"black_顶栏"] forBarMetrics:UIBarMetricsDefault];
        }
#endif
}

- (void)firstLaunch
{
    //判断是否第一次启动
    if(![[NSUserDefaults standardUserDefaults] boolForKey:FirstLaunch])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FirstLaunch];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSArray * topics = @[@"宝宝出生",@"宝宝满月",@"会叫爸爸了",@"会叫妈妈了",@"会爬了",@"会走了",@"一周岁了"];
        
        for(NSString * str in topics)
        {
            Topic * topic = [Topic MR_createEntity];
            topic.topic = str;
            [PersistentStore save];
        }
    }
}


- (void)fetchConfig
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    if(user)
    {
        [[HttpService sharedInstance] getUserSetting:@{@"uid":user.uid} completionBlock:^(id object) {
            NSLog(@"加载配置成功.");
        } failureBlock:^(NSError *error, NSString *responseString) {
            NSLog(@"加载配置失败.");
        }];
    }
}


@end
