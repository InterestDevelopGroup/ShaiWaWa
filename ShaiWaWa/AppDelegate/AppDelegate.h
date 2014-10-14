//
//  AppDelegate.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController * navigationController;
@property (strong, nonatomic) NSString *postValidateType;
@property (strong, nonatomic) NSString *postValidatePhoneNum;
@property (strong, nonatomic) NSString *postValidateCore;
@property (strong, nonatomic) NSString *postValidateCoreTime;


@property (strong, nonatomic) NSString *deleteDyId;




@end
