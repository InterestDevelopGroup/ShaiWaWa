//
//  MainMenu.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MainMenu.h"

@implementation MainMenu
@synthesize user;
@synthesize addBabyButton,babyListButton,myGoodFriendButton,searchFriendButton,settingButton,feeBackButton,exitButton;
@synthesize touXiangImgView,nameLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *menuBg = [UIImage imageNamed:@"main_2-bg.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:menuBg];
        imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        [self addSubview:imageView];
        
        CGRect frame = CGRectMake(0, 0, self.bounds.size.width-6, 60);
        user = [[UIView alloc] initWithFrame:frame];
        user.backgroundColor = [UIColor clearColor];
        [self addSubview:user];
        
        touXiangImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_2-pic.png"]];
        touXiangImgView.frame = CGRectMake(30, 20, 35, 35);
        [user addSubview:touXiangImgView];
        
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 80, 30)];
        nameLabel.text = @"老张";
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:nameLabel];
        
        UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
        UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
        jianTou.frame = CGRectMake(user.bounds.size.width-28, 34, 7, 11);
        [user addSubview:jianTou];
        
        UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userViewTouchEvent)];
        
        [user addGestureRecognizer:userTap];
        
        UIImageView *line0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_line.png"]];
        
        line0.frame = CGRectMake(0,64, self.bounds.size.width-7, 1);
        
        [self addSubview:line0];
        
        //添加宝宝按钮
        addBabyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBabyButton setFrame:CGRectMake(0, 79, (self.bounds.size.width-6)/2, 57)];
        [addBabyButton setImage:[UIImage imageNamed:@"main_tianjiabaobei.png"] forState:UIControlStateNormal];
        [self addSubview:addBabyButton];
        
        UILabel *lineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake((self.bounds.size.width-6)/2+1, 64, 1, 270)];
        lineLabel1.alpha = 0.5;
        lineLabel1.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineLabel1];
        
        babyListButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [babyListButton setFrame:CGRectMake((self.bounds.size.width-6)/2, 79, (self.bounds.size.width-6)/2, 57)];
        [babyListButton setImage:[UIImage imageNamed:@"main_baobaoliebiao.png"] forState:UIControlStateNormal];
        [self addSubview:babyListButton];
        
        UIImageView *line1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_line.png"]];
        
        line1.frame = CGRectMake(0,154, self.bounds.size.width-7, 1);
        
        [self addSubview:line1];
        
        myGoodFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [myGoodFriendButton setFrame:CGRectMake(0, 169, (self.bounds.size.width-6)/2, 57)];
        [myGoodFriendButton setImage:[UIImage imageNamed:@"main_wodehaoyou.png"] forState:UIControlStateNormal];
        [self addSubview:myGoodFriendButton];
        
        searchFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchFriendButton setFrame:CGRectMake((self.bounds.size.width-6)/2, 169, (self.bounds.size.width-6)/2, 57)];
        [searchFriendButton setImage:[UIImage imageNamed:@"main_zhaohaoyou.png"] forState:UIControlStateNormal];
        [self addSubview:searchFriendButton];
        
        UIImageView *line2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_line.png"]];
        
        line2.frame = CGRectMake(0, 244, self.bounds.size.width-7, 1);
        
        [self addSubview:line2];
        
        settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [settingButton setFrame:CGRectMake(0, 259, (self.bounds.size.width-6)/2, 57)];
        [settingButton setImage:[UIImage imageNamed:@"main_shezhi.png"] forState:UIControlStateNormal];
        [self addSubview:settingButton];
        
        feeBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [feeBackButton setFrame:CGRectMake((self.bounds.size.width-6)/2, 259, (self.bounds.size.width-6)/2, 57)];
        [feeBackButton setImage:[UIImage imageNamed:@"main_fankui.png"] forState:UIControlStateNormal];
        [self addSubview:feeBackButton];
        
        UIImageView *line3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_line.png"]];
        
        line3.frame = CGRectMake(0, 334, self.bounds.size.width-7, 1);
        
        [self addSubview:line3];
        
        exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [exitButton setFrame:CGRectMake((self.bounds.size.width-6)/2-77, 345, 154, 27)];
        [exitButton setImage:[UIImage imageNamed:@"main_tuichu.png"] forState:UIControlStateNormal];
        [self addSubview:exitButton];
        
        
        [settingButton addTarget:self action:@selector(showSettingVC:) forControlEvents:UIControlEventTouchUpInside];
        
        [feeBackButton addTarget:self action:@selector(showFeeBackVC:) forControlEvents:UIControlEventTouchUpInside];
        [babyListButton addTarget:self action:@selector(showBabyListVC:) forControlEvents:UIControlEventTouchUpInside];
        [addBabyButton addTarget:self action:@selector(showAddBabyVC:) forControlEvents:UIControlEventTouchUpInside];
        [searchFriendButton addTarget:self action:@selector(showSearchFriendsVC:) forControlEvents:UIControlEventTouchUpInside];
        [myGoodFriendButton addTarget:self action:@selector(showMyGoodFriendListVC:) forControlEvents:UIControlEventTouchUpInside];
        [exitButton addTarget:self action:@selector(quitCurUser:) forControlEvents:UIControlEventTouchUpInside];
        
        

        
    }
    return self;
}


- (void)showSettingVC:(UIButton *)butn
{
    _setBtnBlock(butn);
}
- (void)showFeeBackVC:(UIButton *)butn
{
    _feeBackBtnBlock(butn);
}
- (void)showBabyListVC:(UIButton *)butn
{
    _babyListBtnBlock(butn);
}
- (void)showAddBabyVC:(UIButton *)butn
{
    _addBabyBtnBlock(butn);
}
- (void)showSearchFriendsVC:(UIButton *)butn
{
    _searchFriendBtnBlock(butn);
}
- (void)showMyGoodFriendListVC:(UIButton *)butn
{
    _myGoodFriendBtnBlock(butn);
}
- (void)quitCurUser:(UIButton *)butn
{
    _exitBtnBlock(butn);
}

- (void)userViewTouchEvent
{
    _userVBlock(user);
}
/*
 main_2-pic@2x.png 71*71
 main_tianjiabaobei@2x.png 107*114
 main_baobaoliebiao@2x.png
 main_wodehaoyou@2x.png
 main_zhaohaoyou@2x.png
 main_shezhi@2x.png
 main_fankui@2x.png
 main_tuichu@2x.png 307*54
 */
@end
