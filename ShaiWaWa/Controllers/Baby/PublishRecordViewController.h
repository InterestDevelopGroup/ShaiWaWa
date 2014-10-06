//
//  PublishRecordViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-8-21.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface PublishRecordViewController : CommonViewController
@property (weak, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *babyNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *addMoreButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *visibilityLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UIView *button3View;
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (strong, nonatomic) IBOutlet UIView *recrodView;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (strong, nonatomic) IBOutlet UIImageView *voiceImageView;
@property (weak, nonatomic) IBOutlet UIButton *tecentWeiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaWeiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqSpaceBtn;


@property (strong, nonatomic) IBOutlet UIView *overlayView;

- (IBAction)showMoreBaby:(id)sender;
- (IBAction)showButtonsAction:(id)sender;
- (IBAction)hideOverlay:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)openPictureAction:(id)sender;
- (IBAction)takePictureAction:(id)sender;
- (IBAction)takeMovieAction:(id)sender;
- (IBAction)showAddressAction:(id)sender;
- (IBAction)setVisibilityAction:(id)sender;
- (IBAction)showTopicAction:(id)sender;
- (IBAction)showFriendAction:(id)sender;
- (IBAction)showRecord:(id)sender;
- (IBAction)showShare:(id)sender;
- (IBAction)startRecord:(id)sender;
- (IBAction)stopRecord:(id)sender;
- (IBAction)shareToQQSpace:(id)sender;
- (IBAction)shareToSinaWeibo:(id)sender;
- (IBAction)shareToTecentWeibo:(id)sender;


@end
