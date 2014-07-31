//
//  CContact.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-30.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CContact : NSObject
@property (nonatomic,strong) NSString * firstName;
@property (nonatomic,strong) NSString * lastName;
@property (nonatomic,strong) NSString * compositeName;
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) NSMutableDictionary * phoneInfo;
@property (nonatomic,strong) NSMutableDictionary * emailInfo;
@property (nonatomic,assign) int recordID;
@property (nonatomic,assign) int sectionNumber;


//-(NSString *)getFirstName;
//-(NSString *)getLastName;
//-(NSString *)getFisrtLetterForCompositeName;
@end
