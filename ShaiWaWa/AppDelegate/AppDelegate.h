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

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSString *postValidateType;
@property (strong, nonatomic) NSString *postValidatePhoneNum;
@property (strong, nonatomic) NSString *postValidateCore;
@property (strong, nonatomic) NSString *postValidateCoreTime;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end
