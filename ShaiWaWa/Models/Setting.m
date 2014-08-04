//
//  Setting.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-4.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "Setting.h"
#import "UserInfo.h"

@implementation Setting
@synthesize set_id,userInfo,is_remind,show_position,is_share,upload_audio_only_wifi,upload_image_only_wifi,upload_video_only_wifi,visibility;
- (id)copyWithZone:(NSZone *)zone
{
    userInfo = [[UserInfo alloc] init];
    Setting *set = [[[self class] allocWithZone:zone] init];
    set.set_id = [[self set_id] copy];
    set.userInfo.uid = [self.userInfo.uid copy];
    set.is_remind = [[self is_remind] copy];
    set.visibility = [[self visibility] copy];
    set.show_position = [[self show_position] copy];
    set.is_share = [[self is_share] copy];
    set.upload_video_only_wifi = [[self upload_video_only_wifi] copy];
    set.upload_audio_only_wifi = [[self upload_audio_only_wifi] copy];
    set.upload_image_only_wifi = [[self upload_image_only_wifi] copy];

	return set;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:set_id forKey:@"set_id"];
    [aCoder encodeObject:userInfo.uid forKey:@"uid"];
    [aCoder encodeObject:is_remind forKey:@"is_remind"];
    [aCoder encodeObject:visibility forKey:@"visibility"];
    [aCoder encodeObject:show_position forKey:@"show_position"];
    [aCoder encodeObject:is_share forKey:@"is_share"];
    
    [aCoder encodeObject:upload_video_only_wifi forKey:@"upload_video_only_wifi"];
    [aCoder encodeObject:upload_audio_only_wifi forKey:@"upload_audio_only_wifi"];
    [aCoder encodeObject:upload_image_only_wifi forKey:@"upload_image_only_wifi"];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        
        set_id = [aDecoder decodeObjectForKey:@"set_id"];
        userInfo.uid = [aDecoder decodeObjectForKey:@"uid"];
        is_remind = [aDecoder decodeObjectForKey:@"is_remind"];
        visibility = [aDecoder decodeObjectForKey:@"visibility"];
        show_position = [aDecoder decodeObjectForKey:@"show_position"];
        is_share = [aDecoder decodeObjectForKey:@"is_share"];
        
        upload_video_only_wifi = [aDecoder decodeObjectForKey:@"upload_video_only_wifi"];
        upload_audio_only_wifi = [aDecoder decodeObjectForKey:@"upload_audio_only_wifi"];
        upload_image_only_wifi = [aDecoder decodeObjectForKey:@"upload_image_only_wifi"];

    }
    return self;
}

@end
