//
//  TheThirdPartyLoginView.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-28.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TheThirdPartyLoginView.h"

#import <ShareSDK/ShareSDK.h>

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
             
             NSLog(@"哈哈哈QQ!");
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

@end
