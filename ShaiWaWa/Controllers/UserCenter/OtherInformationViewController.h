//
//  OtherInformationViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface OtherInformationViewController : CommonViewController
@property (strong, nonatomic) IBOutlet UIButton *babyButton;

@property (strong, nonatomic) IBOutlet UIButton *dynamicButton;
@property (strong, nonatomic) IBOutlet UIButton *goodFriendButton;
@property (nonatomic, strong) NSString *otherId;

@property (weak, nonatomic) IBOutlet UIImageView *otherAvatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *otherUserNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *otherSwwNumTextField;
@end
