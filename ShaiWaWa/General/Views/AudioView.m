//
//  AudioView.m
//  ShaiWaWa
//
//  Created by Carl on 14-9-22.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "AudioView.h"

@interface AudioView()<AVAudioPlayerDelegate>
//{
//    UIButton * _button;
//}

@end

@implementation AudioView

- (id)initWithFrame:(CGRect)frame withPath:(NSString *)path
{
    self = [super initWithFrame:frame];
    if (self) {
        self.path = path;
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(5, 5, CGRectGetWidth(self.frame) - 10, CGRectGetHeight(self.frame) - 10);
        [button setImage:[UIImage imageNamed:@"square_bofang-bg"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - 35) , (CGRectGetHeight(frame) - 10) * .5, 10, 10)];
        imageView.image = [UIImage imageNamed:@"square_bofang"];
        imageView.tag = 1000;
        [self addSubview:imageView];
        
        //根据路径拿到音频，并计算期长度
        AVAudioSession * session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        [session setActive:YES error:nil];
        AVAudioPlayer *player = nil;
        
        if([_path hasPrefix:@"http"])   //说明录音文件来自网络
        {
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
            player = [[AVAudioPlayer alloc] initWithData:data error:nil];
        }else                          //说明录音文件来自本地
        {
            player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        }
        _player = player;
        _player.delegate = self;
        
        //显示录音秒数的label
        UILabel * secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame) - 25, (CGRectGetHeight(frame) - 10) * .5, 20, 10)];
        secondsLabel.text = [NSString stringWithFormat:@"%.f\"",player.duration];
        secondsLabel.textAlignment = NSTextAlignmentCenter;
        secondsLabel.font = [UIFont systemFontOfSize:11.0];
        secondsLabel.textColor = [UIColor colorWithRed:104/255.0 green:178.0/255 blue:0.0 alpha:1];
        [self addSubview:secondsLabel];
        
        CGRect closeRect = CGRectMake(CGRectGetWidth(frame) - 20, 8, 15, 15);
        UIButton * closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = closeRect;
        closeBtn.backgroundColor = [UIColor clearColor];
        [closeBtn setImage:[UIImage imageNamed:@"main_cha"] forState:UIControlStateNormal];
        closeBtn.tag = 10000;
        [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
        closeBtn = nil;
        
    }
    return self;
}

- (void)setCloseHidden
{
    UIButton * closeBtn = (UIButton *)[self viewWithTag:10000];
    closeBtn.hidden = YES;
}


- (void)closeAction:(id)sender
{
    if(_deleteBlock)
    {
        _deleteBlock(_path);
    }
    
    if(_path)
    {
        [IO deleteFileAtPath:_path];
    }
    [self removeFromSuperview];
}

#pragma mark - 播放与暂停按钮
- (void)clickAction:(id)sender
{
    if(_path == nil) return ;
    
    
    if(_player != nil && [_player isPlaying])  //判断录音是否为空或者正在播放
    {
        [_player stop];
        
        UIImageView * imageView = (UIImageView *)[self viewWithTag:1000];
        [imageView setImage:[UIImage imageNamed:@"square_bofang"]];
        return ;
    }
    
    [_player prepareToPlay];
    UIImageView * imageView = (UIImageView *)[self viewWithTag:1000];
    
    [_player play];
    [imageView setImage:[UIImage imageNamed:@"停止"]];
    
}

#pragma mark - 音频播放完毕代理方法
- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    UIImageView * imageView = (UIImageView *)[self viewWithTag:1000];
    [imageView setImage:[UIImage imageNamed:@"square_bofang"]];
}

@end
