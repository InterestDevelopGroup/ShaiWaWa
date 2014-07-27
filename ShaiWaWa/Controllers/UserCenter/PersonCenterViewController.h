//
//  PersonCenterViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "UserInfo.h"

@interface PersonCenterViewController : CommonViewController
{
    UserInfo *users;
}
@property (strong, nonatomic) IBOutlet UIButton *babyButton;

@property (strong, nonatomic) IBOutlet UIButton *dynamicButton;
@property (strong, nonatomic) IBOutlet UIButton *goodFriendButton;
@property (strong, nonatomic) IBOutlet UIButton *twoDimensionCodeButton;
@property (strong, nonatomic) IBOutlet UIButton *myCollectionButton;

@property (strong, nonatomic) IBOutlet UIImageView *sheJianBar;
- (IBAction)showUserInfoPageVC:(id)sender;
- (IBAction)showPlatformBind:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *touXiangView;
- (IBAction)changeImg:(id)sender;
- (IBAction)showGoodFriendListVC:(id)sender;
- (IBAction)showMyBabyListVC:(id)sender;
- (IBAction)showMyQRCardVC:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *personalTouXiangImgView;
@property (weak, nonatomic) IBOutlet UILabel *acountName;
@property (weak, nonatomic) IBOutlet UILabel *wawaNum;

@end
