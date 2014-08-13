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

@implementation TheThirdPartyLoginView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"第三方账号登陆";
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
    _xinlanBlock();
    [self sinaLoginEvent];
}

- (void)qqBtnClick
{
    _qqBlock();
    [self qqLoginEvent];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)sinaLoginEvent
{
    //    if (!isRec) {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未连接到网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    //        [alertView show];
    //    }
    //    else
    //    {
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         if (result)
         {
             
             NSLog(@"哈哈哈Sina!");
             //                        PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
             //                        [query whereKey:@"uid" equalTo:[userInfo uid]];
             //                        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
             //                        {
             //                            if ([objects count] == 0)
             //                            {
             //                                 PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
             //                                 [newUser setObject:[userInfo uid] forKey:@"uid"];
             //                                 [newUser setObject:[userInfo nickname] forKey:@"name"];
             //                                 [newUser setObject:[userInfo icon] forKey:@"icon"];
             //                                 [newUser saveInBackground];
             //                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
             //                                 [alertView show];
             //                                 [alertView release];
             //                            }
             //                            else
             //                            {
             //                                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
             //                                 [alertView show];
             //                                 [alertView release];
             //                            }
             //                        }];
         }
         //            MainViewController *mainVC = [[[MainViewController alloc] init] autorelease];
         //            [self.navigationController pushViewController:mainVC animated:YES];
     }];
    //}
}

- (void)qqLoginEvent
{
    //    if (!isRec) {
    //        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"未连接到网络" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    //        [alertView show];
    //    }
    //    else
    //    {
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         if (result)
         {
             
             [[HttpService sharedInstance] openLogin:@{@"openid":[userInfo uid],
                                                       @"type":@"1"} completionBlock:^(id object) {
                                                           NSLog(@"%@",object);
             } failureBlock:^(NSError *error, NSString *responseString) {
                 NSLog(@"%@",responseString);
             }];
             
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
//             NSLog(@"设置用户的原始数据信息:%@",[userInfo setSourceData:<#(NSDictionary *)#>])
//             NSLog(@"设置授权凭证:%@",[userInfo setCredential:<#(id<ISSPlatformCredential>)#>]);
             NSLog(@"获取用户注册时间:%f",[userInfo regAt]);
             NSLog(@"获取用户个人头像:%@",[userInfo profileImage]);
             NSLog(@"获取用户等级%d",[userInfo level]);
             NSLog(@"获取用户性别:%d",[userInfo gender]);
             NSLog(@"获取用户关注数:%d",[userInfo friendCount]);
             NSLog(@"获取用户粉丝数:%d",[userInfo followerCount]);
             NSLog(@"获取用户的教育信息列表:%@",[userInfo educations]);
//             NSLog(@"获取授权凭证%@",[userInfo credential]);
             NSLog(@"获取用户生日:%@",[userInfo birthday]);
             NSLog(@"%@",[[userInfo credential] token]);
         }
     }];
}

@end
