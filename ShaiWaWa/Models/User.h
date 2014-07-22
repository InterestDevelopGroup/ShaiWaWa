//
//  User.h
//  ClairAudient
//
//  Created by Carl on 14-1-19.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BaseModel.h"

@interface User : BaseModel

//@property (nonatomic,strong) NSString * hw_id;
@property (nonatomic,strong) NSString * username;
//@property (nonatomic,strong) NSString * email;
//@property (nonatomic,strong) NSString * teleno;
//@property (nonatomic,strong) NSString * realname;
//@property (nonatomic,strong) NSString * nickname;
//@property (nonatomic,strong) NSString * gender;
////@property (nonatomic,strong) NSString * free;
//@property (nonatomic,strong) NSString * birthday;
//@property (nonatomic,strong) NSString * investment;
//@property (nonatomic,strong) NSString * photo;
//@property (nonatomic,strong) NSString * place;
//@property (nonatomic,strong) NSString * belongs;
@property (nonatomic,strong) NSString * password;
//@property (nonatomic,strong) NSString * version;
+ (void)saveToLocal:(User *)user;
+ (User *)userFromLocal;
+ (void)deleteUserFromLocal;
@end
