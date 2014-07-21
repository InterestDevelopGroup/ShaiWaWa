//
//  MainMenu.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MainMenu;
typedef void(^mainMenuBar)(MainMenu *);

typedef void(^UserView)(UIView *);
typedef void(^AddBabyButton)(UIButton *);
typedef void(^BabyListButton)(UIButton *);
typedef void(^MyGoodFriendButton)(UIButton *);
typedef void(^SearchFriendButton)(UIButton *);
typedef void(^SettingButton)(UIButton *);
typedef void(^FeeBackButton)(UIButton *);
typedef void(^ExitButton)(UIButton *);

@interface MainMenu : UIView
@property (strong, nonatomic) UIImageView *touXiangImgView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIView *user;
@property (strong, nonatomic) UIButton *addBabyButton, *babyListButton, *myGoodFriendButton, *searchFriendButton, *settingButton, *feeBackButton, *exitButton;

@property (nonatomic,copy) mainMenuBar menuBlock;

@property (nonatomic,copy) AddBabyButton addBabyBtnBlock;
@property (nonatomic,copy) BabyListButton babyListBtnBlock;
@property (nonatomic,copy) MyGoodFriendButton myGoodFriendBtnBlock;
@property (nonatomic,copy) SearchFriendButton searchFriendBtnBlock;
@property (nonatomic,copy) SettingButton setBtnBlock;
@property (nonatomic,copy) FeeBackButton feeBackBtnBlock;
@property (nonatomic,copy) ExitButton exitBtnBlock;
@property (nonatomic,copy) UserView userVBlock;

@end
