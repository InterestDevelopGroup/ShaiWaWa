//
//  ChooseModeViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "UserInfo.h"

typedef void(^SpecialBlock)(NSMutableArray *);

@interface ChooseModeViewController : CommonViewController<UITableViewDataSource, UITableViewDelegate>
{
    BOOL isMenuShown,isDropMenuShown,isShareViewShown;
    UserInfo *users;
    NSMutableArray *dyArray;
}

@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (strong, nonatomic) IBOutlet UIView *menuGray;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *userViewTap;
@property (strong, nonatomic) IBOutlet UIView *grayDropView;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *guoLVTap;

@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnView;
@property (weak, nonatomic) IBOutlet UITableView *dynamicPageTableView;
@property (weak, nonatomic) IBOutlet UIView *grayShareView;

@property (weak, nonatomic) IBOutlet UIButton *releaseBtn;
@property (weak, nonatomic) IBOutlet UIView *mainAddView;

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (nonatomic, strong) NSMutableArray *dyArray;

@property (nonatomic, strong) SpecialBlock specialBlock;


- (IBAction)showSearchFriendsVC:(id)sender;
- (IBAction)showReleaseVC:(id)sender;
- (IBAction)showAddBabyVC:(id)sender;
- (IBAction)hideGayShareV:(id)sender;
- (IBAction)showGrayDropV:(id)sender;
- (IBAction)hideMenuGray:(id)sender;
- (IBAction)showSquaresVC:(id)sender;
- (IBAction)hideGrayDropView:(id)sender;
- (IBAction)userViewTouchEvent:(id)sender;

@end
