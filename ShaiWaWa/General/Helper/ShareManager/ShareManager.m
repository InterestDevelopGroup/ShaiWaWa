//
//  ShareManager.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-25.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ShareManager.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/QZoneConnection.h>

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
    

    //微信
    //wxac01db4d5123ff1f
    [ShareSDK connectWeChatWithAppId:@"wxac01db4d5123ff1f" wechatCls:[WXApi class]];
    [ShareSDK importWeChatClass:[WXApi class]];
    
    //添加QQ空间应用
    
    /*
     [ShareSDK connectQZoneWithAppKey:@"100371282"
     appSecret:@"aed9b0303e3ed1e27bae87c33761161d"];
     */
    
    [ShareSDK connectQZoneWithAppKey:@"1102927704"
                           appSecret:@"kXvZ57IaEyknuUiy"
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
    NSString * url = @"http://www.baidu.com";
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
@end
