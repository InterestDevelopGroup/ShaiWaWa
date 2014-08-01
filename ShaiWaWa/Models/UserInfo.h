//
//  UserInfo.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-23.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCopying, NSCoding> {
    
    NSString *uid;            //用户id
	NSString *username;       //用户昵称
	NSString *password;       //密码
    NSString *phone;          //手机号码
    NSString *sww_number;     //晒娃娃号
    NSString *sex;            //性别
    NSString *avatar;         //用户头像
//    NSString *qq;
//    NSString *weibo;
//    NSString *wechat;
    
}
@property (nonatomic,retain)NSString *uid;
@property (nonatomic,retain)NSString *username;
@property (nonatomic,retain)NSString *password;
@property (nonatomic,retain)NSString *phone;
@property (nonatomic,retain)NSString *sww_number;
@property (nonatomic,retain)NSString *sex;
@property (nonatomic,retain)NSString *avatar;
//@property (nonatomic,retain)NSString *qq;
//@property (nonatomic,retain)NSString *weibo;
//@property (nonatomic,retain)NSString *wechat;

- (UserInfo *)initWithName :(NSString*)_username
                     and : (NSString *)_password;
@end
