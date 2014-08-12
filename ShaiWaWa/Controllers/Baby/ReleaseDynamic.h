//
//  ReleaseDynamic.h
//  ShaiWaWa
//
//  Created by Cheung on 14-7-20.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ReleaseDynamic : CommonViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,AVAudioPlayerDelegate>
{
    BOOL isSoundBar, isShareBar;
    
}
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
- (IBAction)showCanSeeView:(id)sender;

- (IBAction)onlyParentClick:(id)sender;
- (IBAction)onlyFriendClick:(id)sender;
- (IBAction)allPublicClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *onlyParentBtn_4s;
@property (weak, nonatomic) IBOutlet UIButton *onlyFriendBtn_4s;
@property (weak, nonatomic) IBOutlet UIButton *allPublicBtn_4s;

@property (weak, nonatomic) IBOutlet UIButton *onlyParentBtn;
@property (weak, nonatomic) IBOutlet UIButton *onlyFriendBtn;
@property (weak, nonatomic) IBOutlet UIButton *allPublicBtn;

@property (weak, nonatomic) IBOutlet UIView *soundXiaView;

@property (weak, nonatomic) IBOutlet UIView *shareXiaView;
@property (weak, nonatomic) IBOutlet UIView *topView;
- (IBAction)hideXialaView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *xialaGrayV;
@property (weak, nonatomic) IBOutlet UITextView *dy_contextTextField;
- (IBAction)recordBtnDownEvent:(id)sender;
- (IBAction)recordBtnUpEvent:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *huaTongButton;
@property (weak, nonatomic) IBOutlet UITextView *dyContextTextView;

@property (weak, nonatomic) IBOutlet UIImageView *babyAvatarImgView;

@property (weak, nonatomic) IBOutlet UILabel *babyNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *babySelectJianTouImgView;
- (IBAction)changeAnotherBaby:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteVoiceButton;
- (IBAction)playVoiceEvent:(id)sender;
- (IBAction)deleteVoiceEvent:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *scrollSubView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewForMedia;
@property (weak, nonatomic) IBOutlet UIButton *addMoreMediaButton;

@end
