//
//  ChooseModeViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "UserInfo.h"

@interface ChooseModeViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
{
    BOOL isMenuShown,isDropMenuShown,isShareViewShown;
    UserInfo *users;
}
- (IBAction)showSearchFriendsVC:(id)sender;

- (IBAction)showAddBabyVC:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *menuGray;
- (IBAction)hideMenuGray:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *userViewTap;
- (IBAction)userViewTouchEvent:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *grayDropView;
- (IBAction)hideGrayDropView:(id)sender;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *guoLVTap;
- (IBAction)showGrayDropV:(id)sender;
- (IBAction)showSquaresVC:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnView;
@property (weak, nonatomic) IBOutlet UITableView *dynamicPageTableView;
@property (weak, nonatomic) IBOutlet UIView *grayShareView;
- (IBAction)hideGayShareV:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *releaseBtn;
- (IBAction)showReleaseVC:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *mainAddView;

@property (weak, nonatomic) IBOutlet UIView *shareView;

@end
