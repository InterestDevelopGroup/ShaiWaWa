//
//  ReleaseDynamic.h
//  ShaiWaWa
//
//  Created by Cheung on 14-7-20.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface ReleaseDynamic : CommonViewController
- (IBAction)showTopicVC:(id)sender;
- (IBAction)showChooseFriendVC:(id)sender;

- (IBAction)showDroSoundBar:(id)sender;

- (IBAction)showSynShareBar:(id)sender;
- (IBAction)showLocationVC:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *letPersonSawLabel;
@property (weak, nonatomic) IBOutlet UILabel *addr_4s_Label;
@property (weak, nonatomic) IBOutlet UILabel *addr_Label;
@property (weak, nonatomic) IBOutlet UIButton *addMore;
@property (weak, nonatomic) IBOutlet UIButton *addMore_4s;
@property (weak, nonatomic) IBOutlet UIView *picOrvideoSelectBar_4s;
@property (weak, nonatomic) IBOutlet UIView *picOrvideoSelectBar;
- (IBAction)showLocalPhoto:(id)sender;
- (IBAction)showLocalCamer:(id)sender;
- (IBAction)showLocalFilm:(id)sender;
- (IBAction)showGrayTwoBtnView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *grayTwoView;
@property (weak, nonatomic) IBOutlet UIView *grayTwoView_4s;
- (IBAction)hideGrayTwoView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *canSeeView;
@property (weak, nonatomic) IBOutlet UIView *canSeeView_4s;
- (IBAction)hideCanSeeView:(id)sender;
@end
