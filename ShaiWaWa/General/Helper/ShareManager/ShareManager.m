//
//  ShareManager.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ShareManager.h"

#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/QZoneConnection.h>
#import "UserInfo.h"
#import "UserDefault.h"
@implementation ShareManager

+ (instancetype)sharePlatform
{
    static ShareManager *platform = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        platform = [[ShareManager alloc] init];
    });
    return platform;
}




- (void)configShare
{
    [ShareSDK registerApp:@"2075d02bcb88"];
    [ShareSDK importWeChatClass:[WXApi class]];
    
    //新浪微博
     [ShareSDK connectSinaWeiboWithAppKey:@"1000068529"
     appSecret:@"5258f9253910966082e8828fe092841d"
     redirectUri:@"http://www.gzinterest.com"];
    
//    [ShareSDK connectSinaWeiboWithAppKey:@"3760443588"
//                               appSecret:@"13662c0f4a3d11a596e933359ac98849"
//                             redirectUri:@"http://www.gzinterest.com"];

    

    //微信
    //wxac01db4d5123ff1f
    [ShareSDK connectWeChatWithAppId:@"wxac01db4d5123ff1f" wechatCls:[WXApi class]];
    [ShareSDK importWeChatClass:[WXApi class]];
    
    //添加QQ空间应用
    
    /*
     [ShareSDK connectQZoneWithAppKey:@"100371282"
     appSecret:@"aed9b0303e3ed1e27bae87c33761161d"];
     */
    
    [ShareSDK connectQZoneWithAppKey:@"1102109842"
                           appSecret:@"tOwcoJihUTQGd12L"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    
    //导入QQ互联和QQ好友分享需要的外部库类型，如果不需要QQ空间SSO和QQ好友分享可以不调用此方法
    [ShareSDK importQQClass:[QQApiInterface class]
            tencentOAuthCls:[TencentOAuth class]];
}

- (void)shareToWeiXin
{
     [self share:ShareTypeWeixiSession];
}

- (void)shareToWeiXinFriend
{
    [self share:ShareTypeWeixiSession];
}


- (void)shareToWeiXinCycle
{
     [self share:ShareTypeWeixiTimeline];
}
- (void)shareToSinaWeiBo
{
     [self share:ShareTypeSinaWeibo];
}
- (void)shareToQzone
{
     [self share:ShareTypeQQSpace];
}

- (void)share:(ShareType)type
{
    NSString * content = @"分享内容";
    id<ISSCAttachment>  image = [ShareSDK pngImageWithImage:nil];
    NSString * title = @"分享";
    NSString * url = @"http://www.gzinterest.com";
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:content
                                                image:image
                                                title:title
                                                  url:url
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:SSAuthViewStyleFullScreenPopup
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:title oneKeyShareList:nil qqButtonHidden:YES wxSessionButtonHidden:YES wxTimelineButtonHidden:YES showKeyboardOnAppear:YES shareViewDelegate:nil friendsViewDelegate:nil picViewerViewDelegate:nil];
    
    [ShareSDK shareContent:publishContent type:type authOptions:authOptions shareOptions:shareOptions statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSPublishContentStateSuccess)
        {
            NSLog(@"发表成功");
        }
        else if (state == SSPublishContentStateFail)
        {
            NSLog(@"发布失败!error code == %d, error code == %@", [error errorCode], [error errorDescription]);
        }
    }];
}


- (void)invitationWeXinFriend:(NSString *)text withURL:(NSString *)url
{
    id<ISSContent> publishContent = [ShareSDK content:text
                                       defaultContent:text
                                                image:nil
                                                title:@"邀请好友"
                                                  url:url
                                          description:text
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:@"邀请好友" oneKeyShareList:nil qqButtonHidden:YES wxSessionButtonHidden:YES wxTimelineButtonHidden:YES showKeyboardOnAppear:YES shareViewDelegate:nil friendsViewDelegate:nil picViewerViewDelegate:nil];
    
    [ShareSDK shareContent:publishContent type:ShareTypeWeixiSession authOptions:authOptions shareOptions:shareOptions statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (state == SSPublishContentStateSuccess)
        {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alertView show];
            NSLog(@"发表成功");
        }
        else if (state == SSPublishContentStateFail)
        {
            
            NSLog(@"发布失败!error code == %d, error == %@", [error errorCode], [error errorDescription]);
            NSString * msg = @"分享失败.";
            if([error errorCode] == -22003)
            {
                msg = @"未安装客户端.";
            }
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }];

}

- (void)shareWithType:(ShareType)type withContent:(NSString *)content withImage:(UIImage *)image
{
    if(content == nil)
    {
        content = @"分享内容";
    }
    id<ISSCAttachment> attachment = nil;
    if(image != nil)
    {
        attachment = [ShareSDK pngImageWithImage:image];
    }
    
    NSString * title = content;
    NSString * url = @"http://www.gzinterest.com";
    id<ISSContent> publishContent = [ShareSDK content:title
                                       defaultContent:title
                                                image:attachment
                                                title:title
                                                  url:url
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:title oneKeyShareList:nil qqButtonHidden:YES wxSessionButtonHidden:YES wxTimelineButtonHidden:YES showKeyboardOnAppear:YES shareViewDelegate:nil friendsViewDelegate:nil picViewerViewDelegate:nil];
    
    [ShareSDK shareContent:publishContent type:type authOptions:authOptions shareOptions:shareOptions statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (state == SSPublishContentStateSuccess)
        {
            /*
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alertView show];
            */
            NSLog(@"发表成功");
        }
        else if (state == SSPublishContentStateFail)
        {
            
            NSLog(@"发布失败!error code == %d, error == %@", [error errorCode], [error errorDescription]);
            NSString * msg = @"分享失败.";
            if([error errorCode] == -22003)
            {
                msg = @"未安装客户端.";
            }
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }];
}

- (void)shareWithType:(ShareType)type withContent:(NSString *)content withImagePath:(NSString *)path
{
    if(content == nil)
    {
        content = @"分享内容";
    }
    id<ISSCAttachment> attachment = nil;
    if(path != nil)
    {
        attachment = [ShareSDK imageWithUrl:path];
    }
    
    NSString * title = content;
    NSString * url = @"http://www.gzinterest.com";
    id<ISSContent> publishContent = [ShareSDK content:title
                                       defaultContent:title
                                                image:attachment
                                                title:title
                                                  url:url
                                          description:content
                                            mediaType:SSPublishContentMediaTypeNews];
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:NO
                                                         authViewStyle:SSAuthViewStyleModal
                                                          viewDelegate:nil
                                               authManagerViewDelegate:nil];
    
    id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:title oneKeyShareList:nil qqButtonHidden:YES wxSessionButtonHidden:YES wxTimelineButtonHidden:YES showKeyboardOnAppear:YES shareViewDelegate:nil friendsViewDelegate:nil picViewerViewDelegate:nil];
    
    [ShareSDK shareContent:publishContent type:type authOptions:authOptions shareOptions:shareOptions statusBarTips:YES result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        
        if (state == SSPublishContentStateSuccess)
        {
            /*
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"分享成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alertView show];
            */
            NSLog(@"发表成功");
        }
        else if (state == SSPublishContentStateFail)
        {
            
            NSLog(@"发布失败!error code == %d, error == %@", [error errorCode], [error errorDescription]);
            NSString * msg = @"分享失败.";
            if([error errorCode] == -22003)
            {
                msg = @"未安装客户端.";
            }
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
    }];
}


- (void)shareToSinaWeiBoInBackground:(NSString *)text withURL:(NSString *)url
{
    //发送微博
    NSMutableDictionary * dic = [@{} mutableCopy];
    dic[@"access_token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"SIAN_ACCESS_TOKEN"];
    dic[@"status"] = text;
    dic[@"visible"] = @"0";
    [[HttpService sharedInstance] post:@"https://api.weibo.com/2/statuses/update.json" withParams:dic completionBlock:^(id obj) {
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];

}


- (void)shareToQzoneInBackground:(NSString *)text withURL:(NSString *)url
{
    //https://graph.qq.com/t/add_t
    
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    if(user.tecent_openId == nil)
    {
        return ;
    }
    
    NSMutableDictionary * dic = [@{} mutableCopy];
    dic[@"access_token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"QQ_ACCESS_TOKEN"];
    dic[@"oauth_consumer_key"] = @"1102109842";
    dic[@"openid"] = user.tecent_openId;
    dic[@"content"] = text;
    dic[@"format"] = @"json";
    [[HttpService sharedInstance] post:@"https://graph.qq.com/t/add_t" withParams:dic completionBlock:^(id obj) {
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];

    
}

@end
