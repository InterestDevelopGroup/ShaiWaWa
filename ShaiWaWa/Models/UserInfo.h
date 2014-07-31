//
//  UserInfo.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCopying, NSCoding> {
    
    NSString *uid;
	NSString *username;
	NSString *password;
    NSString *phone;
    NSString *sww_number;
    NSString *sex;
}
@property (nonatomic,retain)NSString *uid;
@property (nonatomic,retain)NSString *username;
@property (nonatomic,retain)NSString *password;
@property (nonatomic,retain)NSString *phone;
@property (nonatomic,retain)NSString *sww_number;
@property (nonatomic,retain)NSString *sex;

- (UserInfo *)initWithName :(NSString*)_username
                     and : (NSString *)_password;
@end
