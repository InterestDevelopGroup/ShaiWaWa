//
//  Setting.h
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;
@interface Setting : NSObject<NSCopying, NSCoding> {
    
    NSString *set_id;         //
	UserInfo *userInfo;       //
	NSString *is_remind;      //新信息提醒(1:Yes 0:No)
    NSString *visibility;     //动态可见度(1:公开 2:亲友可见 3:父母可见)
    NSString *show_position;  //是否附加地理位置(1:是 0:否)
    NSString *is_share;       //自动分享到绑定的社交平台(1:是 0:否)
    
//    NSString *tecent_wb;      //
//    NSString *sina_wb;
//    NSString *qq_qzone;
    
    NSString *upload_video_only_wifi; //是否在wifi下才上传视频(1:Yes 0:No)
    NSString *upload_audio_only_wifi; //是否在wifi下才上传音频(1:Yes 0:No)
    NSString *upload_image_only_wifi; //是否在wifi下才上传图片(1:Yes 0:No)
}

@property(nonatomic, retain) NSString *set_id;
@property(nonatomic, retain) UserInfo *userInfo;
@property(nonatomic, retain) NSString *is_remind;
@property(nonatomic, retain) NSString *visibility;
@property(nonatomic, retain) NSString *show_position;
@property(nonatomic, retain) NSString *is_share;

//@property(nonatomic, retain) NSString *tecent_wb;
//@property(nonatomic, retain) NSString *sina_wb;
//@property(nonatomic, retain) NSString *qq_qzone;

@property(nonatomic, retain) NSString *upload_video_only_wifi;
@property(nonatomic, retain) NSString *upload_audio_only_wifi;
@property(nonatomic, retain) NSString *upload_image_only_wifi;

@end
