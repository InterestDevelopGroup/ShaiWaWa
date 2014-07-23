//
//  UserInfo.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCopying, NSCoding> {
    
	NSString *username;
	NSString *password;
}
@property (nonatomic,retain)NSString *username;
@property (nonatomic,retain)NSString *password;

- (UserInfo *)initWithName :(NSString*)_username
                     and : (NSString *)_password;
@end
