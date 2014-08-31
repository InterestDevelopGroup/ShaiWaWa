//
//  VideoConvertHelper.m
//  ShaiWaWa
//
//  Created by Carl on 14-8-22.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "VideoConvertHelper.h"
@import AVFoundation;
@import CoreMedia;
@import MediaPlayer;
@implementation VideoConvertHelper
+ (instancetype)sharedHelper
{
    static VideoConvertHelper * helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[VideoConvertHelper alloc] init];
    });
    
    return helper;
}

- (id)init
{
    if((self = [super init])) {
        
    }
    return self;
}

- (void)convertMov:(NSString *)movPath toMP4:(NSString *)mp4Path
{
    if(movPath == nil)
    {
        NSLog(@"The mov path is nil.");
        return ;
    }
    
    if(mp4Path == nil)
    {
        NSLog(@"The mp4 path is nil.");
        return ;
    }
    AVURLAsset * avAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:movPath] options:nil];
    NSArray * compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    if(![compatiblePresets containsObject:AVAssetExportPresetMediumQuality])
    {
        NSLog(@"AVAssetExportPresetMediumQuality is not compatible.");
        return ;
    }
    
    AVAssetExportSession * session = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = [NSURL fileURLWithPath:mp4Path];
    session.outputFileType = AVFileTypeMPEG4;
    session.shouldOptimizeForNetworkUse = YES;
    [session exportAsynchronouslyWithCompletionHandler:^{
        [IO deleteFileAtPath:movPath];
        switch ([session status]) {
            case AVAssetExportSessionStatusFailed:
            {
                NSLog(@"Failed.");
                if(self.failureBlock)
                {
                    self.failureBlock();
                }
                break;
            }
            case AVAssetExportSessionStatusCancelled:
                NSLog(@"Cancel.");
                if(self.cancelBlock)
                {
                    self.cancelBlock();
                }
                break;
            case AVAssetExportSessionStatusCompleted:
            {
                NSLog(@"Successful!");
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(self.finishBlock)
                    {
                        self.finishBlock();
                    }
                });
                break;
            }
            default:
                break;
        }
    }];
    
}

- (UIImage *)getVideoThumb:(NSString *)path
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:path] options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return thumb;
}

- (UIImage *)getVideoFirstFrame:(NSString *)path
{
    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc]
                                   initWithContentURL:[NSURL fileURLWithPath:path]];
    mp.initialPlaybackTime = 0;
    mp.currentPlaybackTime = 0;
    UIImage *img = [mp thumbnailImageAtTime:0.0
                                 timeOption:MPMovieTimeOptionNearestKeyFrame];
    [mp stop];
    return img;

}
@end
