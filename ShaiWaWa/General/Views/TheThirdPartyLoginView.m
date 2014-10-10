//
//  TheThirdPartyLoginView.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TheThirdPartyLoginView.h"

#import <ShareSDK/ShareSDK.h>

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "UserDefault.h"
@implementation TheThirdPartyLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"第三方账号登录";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor lightGrayColor];
        _titleLabel.frame = CGRectMake(62, 15, 119, 21);
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        _xinlanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_xinlanButton setTitle:@"新浪微博" forState:UIControlStateNormal];
        [_xinlanButton setTitleEdgeInsets:UIEdgeInsetsMake(60, -45, 0, 0)];
        [_xinlanButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_xinlanButton setFrame:CGRectMake(50, 49, 40, 47)];
        [_xinlanButton setImage:[UIImage imageNamed:@"login_xinlang.png"] forState:UIControlStateNormal];
        [_xinlanButton addTarget:self action:@selector(xinlanBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _xinlanButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
        
        _qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qqButton setTitle:@"腾讯QQ" forState:UIControlStateNormal];
        [_qqButton setTitleEdgeInsets:UIEdgeInsetsMake(60, -45, 0, 0)];
        [_qqButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_qqButton setFrame:CGRectMake(150, 53, 40, 43)];
        [_qqButton setImage:[UIImage imageNamed:@"login_qq.png"] forState:UIControlStateNormal];
        [_qqButton addTarget:self action:@selector(qqBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _qqButton.titleLabel.font = [UIFont systemFontOfSize:10.0];
        
        
        [self addSubview:_titleLabel];
        [self addSubview:_xinlanButton];
        [self addSubview:_qqButton];
    }
    return self;
}

- (void)xinlanBtnClick
{
    [self sinaLoginEvent];
}

- (void)qqBtnClick
{
    [self qqLoginEvent];
}

- (void)sinaLoginEvent
{

    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         
         if(error)
         {
             NSLog(@"%@",error);
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"授权失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alertView show];
             alertView = nil;
             return  ;
         }
         
         if(!result)
         {
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"登陆失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alertView show];
             alertView = nil;
             return ;
             
         }
         
         NSLog(@"获取用户所属平台类型:%d",[userInfo type]);
         NSLog(@"获取用户个人主页:%@",[userInfo url]);
         NSLog(@"获取用户认证类型:%d",[userInfo verifyType]);
         NSLog(@"获取用户职业信息:%@",[userInfo works]);
         NSLog(@"获取用户id:%@",[userInfo uid]);
         NSLog(@"获取用户昵称:%@",[userInfo nickname]);
         NSLog(@"获取用户个人简介:%@",[userInfo aboutMe]);
         NSLog(@"获取用户所属的应用:%@",[userInfo app]);
         NSLog(@"获取用户的原始数据信息:%@",[userInfo sourceData]);
         NSLog(@"获取用户分享数:%d",[userInfo shareCount]);
         NSLog(@"获取用户注册时间:%f",[userInfo regAt]);
         NSLog(@"获取用户个人头像:%@",[userInfo profileImage]);
         NSLog(@"获取用户等级%d",[userInfo level]);
         NSLog(@"获取用户性别:%d",[userInfo gender]);
         NSLog(@"获取用户关注数:%d",[userInfo friendCount]);
         NSLog(@"获取用户粉丝数:%d",[userInfo followerCount]);
         NSLog(@"获取用户的教育信息列表:%@",[userInfo educations]);
         NSLog(@"获取用户生日:%@",[userInfo birthday]);
         NSLog(@"token:%@",[[userInfo credential] token]);
         NSLog(@"secret:%@",[[userInfo credential] secret]);
         
         [self loginWithUserInfo:userInfo openid:[userInfo uid] type:@"2"];
     }];
    
}

- (void)qqLoginEvent
{

    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         
         if(error)
         {
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"授权失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alertView show];
             alertView = nil;
             return ;
         }
         
         if(!result)
         {
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"登陆失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alertView show];
             alertView = nil;
             return ;

         }
         
         NSLog(@"获取用户所属平台类型:%d",[userInfo type]);
         NSLog(@"获取用户个人主页:%@",[userInfo url]);
         NSLog(@"获取用户认证类型:%d",[userInfo verifyType]);
         NSLog(@"获取用户职业信息:%@",[userInfo works]);
         NSLog(@"获取用户id:%@",[userInfo uid]);
         NSLog(@"获取用户昵称:%@",[userInfo nickname]);
         NSLog(@"获取用户个人简介:%@",[userInfo aboutMe]);
         NSLog(@"获取用户所属的应用:%@",[userInfo app]);
         NSLog(@"获取用户的原始数据信息:%@",[userInfo sourceData]);
         NSLog(@"获取用户分享数:%d",[userInfo shareCount]);
         NSLog(@"获取用户注册时间:%f",[userInfo regAt]);
         NSLog(@"获取用户个人头像:%@",[userInfo profileImage]);
         NSLog(@"获取用户等级%d",[userInfo level]);
         NSLog(@"获取用户性别:%d",[userInfo gender]);
         NSLog(@"获取用户关注数:%d",[userInfo friendCount]);
         NSLog(@"获取用户粉丝数:%d",[userInfo followerCount]);
         NSLog(@"获取用户的教育信息列表:%@",[userInfo educations]);
         NSLog(@"获取用户生日:%@",[userInfo birthday]);
         NSLog(@"token:%@",[[userInfo credential] token]);
         NSLog(@"secret:%@",[[userInfo credential] secret]);
         //[self loginWithUserInfo:userInfo type:@"1"];
         [self getOpenIDWithUserInfo:userInfo type:@"1"];
     }];
}



- (void)getOpenIDWithUserInfo:(id<ISSPlatformUser>) userInfo type:(NSString *)type
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] get:@"https://graph.qq.com/oauth2.0/me" parameters:@{@"access_token":[[userInfo credential] token]} completionBlock:^(id obj) {
        //不需要处理成功返回的数据，因为服务端返回的数据不是json根式
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        NSRange range1 = [responseString rangeOfString:@"{"];
        NSRange range2 = [responseString rangeOfString:@"}"];
        
        NSString * jsonStr = [responseString substringWithRange:NSMakeRange(range1.location, range2.location + 1 - range1.location)];
        NSDictionary * info = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
        //没有出错
        if(info[@"openid"] != nil)
        {
            [self loginWithUserInfo:userInfo openid:info[@"openid"] type:@"1"];
            return ;
        }
        
        //错误提示
        NSString * msg = responseString;
        if(error)
        {
            msg = @"登陆失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}



- (void)loginWithUserInfo:(id<ISSPlatformUser>)userInfo openid:(NSString *)openid type:(NSString *)type
{
     [[HttpService sharedInstance] openLogin:@{@"open_id":openid,
     @"type":type} completionBlock:^(id object) {
         if(object == nil || ![object isKindOfClass:[UserInfo class]])
         {
             NSLog(@"没有绑定账号.");
             [self registerWithUserInfo:userInfo openid:openid type:type];
             return ;
         }
         NSLog(@"%@",object);
         [SVProgressHUD dismiss];
         
         NSString * key = @"QQ_ACCESS_TOKEN";
         if([type isEqualToString:@"1"])
         {
             key = @"QQ_ACCESS_TOKEN";
         }
         else if([type isEqualToString:@"2"])
         {
             key = @"SIAN_ACCESS_TOKEN";
         }
         
         NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
         [userDefault setObject:[[userInfo credential] token] forKey:key];
         [userDefault synchronize];

         if(_bindBlock)
         {
             _bindBlock(object);
         }
         
     } failureBlock:^(NSError *error, NSString *responseString) {
         NSString * msg = responseString;
         if(error)
         {
             msg = @"登陆失败.";
         }
         [SVProgressHUD showErrorWithStatus:msg];
     }];
    
}

- (void)registerWithUserInfo:(id<ISSPlatformUser>)userInfo openid:(NSString *)openid type:(NSString *)type
{
    NSString *sww_Num = [self fitSwwNum];
    
    void (^RegisterBlock)(id<ISSPlatformUser>info,NSString * t);
    RegisterBlock = ^(id<ISSPlatformUser>info,NSString * t){
        
        NSMutableDictionary * params = [@{} mutableCopy];
        params[@"username"] = [info nickname];
        params[@"password"] = @"";
        params[@"phone"] = @"";
        params[@"sww_number"] = sww_Num;
        params[@"type"] = t;
        params[@"open_id"] = openid;
        params[@"validate_code"] = @"";
        [[HttpService sharedInstance] userRegister:params completionBlock:^(id object) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"RegisterSuccess", nil)];
            
            NSString * key = @"QQ_ACCESS_TOKEN";
            if([type isEqualToString:@"1"])
            {
                key = @"QQ_ACCESS_TOKEN";
            }
            else if([type isEqualToString:@"2"])
            {
                key = @"SIAN_ACCESS_TOKEN";
            }
            NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:[[userInfo credential] token] forKey:key];
            [userDefault synchronize];
            
            UserInfo *curUser = [[HttpService sharedInstance] mapModel:[[object objectForKey:@"result"] objectAtIndex:0] withClass:[UserInfo class]];
            
            [[UserDefault sharedInstance] setUserInfo:curUser];
            
            if(_bindBlock)
            {
                _bindBlock(object);
            }

        } failureBlock:^(NSError *error, NSString *responseString) {
            NSString * msg = NSLocalizedString(@"RegisterError", nil);
            if(error == nil)
                msg = responseString;
            [SVProgressHUD showErrorWithStatus:msg];
        }];
        
    };
    

    
    
    [[HttpService sharedInstance] isExists:@{@"sww_number":sww_Num} completionBlock:^(id object) {
        
        RegisterBlock(userInfo,type);
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        if(error)
        {
            NSString * msg = NSLocalizedString(@"RegisterError", nil);
            [SVProgressHUD showErrorWithStatus:msg];
            return ;
        }
        
        [self registerWithUserInfo:userInfo openid:openid type:type];
    }];

}



#pragma mark -- 随机生成一个八位数
- (NSString *)randomNum
{
    //自动生成8位随机密码
    NSTimeInterval random=[NSDate timeIntervalSinceReferenceDate];
    NSString *randomString = [NSString stringWithFormat:@"%.8f",random];
    NSString *randomSww_num = [[randomString componentsSeparatedByString:@"."]objectAtIndex:1];
    return randomSww_num;
}


#pragma mark -- 是否符合晒娃娃号需求
- (NSString *)fitSwwNum
{
    NSString *number = [self randomNum];                      //获取随机数
    int count = 0;
    for (int i = 0; i < 8; i++) {
        char num = [number characterAtIndex:i];
        if (num == '4') {
            count ++;
            if (count > 3) {
                [self fitSwwNum];
            }
            if (i == 7) {
                [self fitSwwNum];
            }
        }
    }
    return number;
}




@end
