//
//  ChooseModeViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChooseModeViewController.h"
#import "ControlCenter.h"
#import "MainMenu.h"
#import "UserInfoPageViewController.h"
#import "SettingViewController.h"
#import "FeeBackViewController.h"
#import "BabyListViewController.h"
#import "MyGoodFriendsListViewController.h"
@interface ChooseModeViewController ()

@end

@implementation ChooseModeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initUI
{
    UIBarButtonItem * leftItem;
    if ([OSHelper iOS7])
    {
        leftItem = [self customBarItem:@"square_cebinlan" action:@selector(showMenu) size:CGSizeMake(40, 30) imageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    }
    else
    {
        leftItem = [self customBarItem:@"square_cebinlan" action:@selector(showMenu)];
    }
    
    self.navigationItem.leftBarButtonItem = leftItem;
    UIImageView *titileImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"square_shaiwawa"]];
    self.navigationItem.titleView = titileImage;
    UIBarButtonItem * rightItem_1 = [self customBarItem:@"square_yanjing" action:nil];
    UIBarButtonItem * rightItem_2 = [self customBarItem:@"square_pinglun-4" action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem_2,rightItem_1];
    isMenuShown = NO;
    MainMenu *mainMenu = [[MainMenu alloc] initWithFrame:CGRectMake(0, 0, 220, 300)];
    mainMenu.userInteractionEnabled = YES;
    //[mainMenu.btn addTarget:self action:@selector(printString) forControlEvents:UIControlEventTouchUpInside];
    [mainMenu.settingButton addTarget:self action:@selector(showSettingVC) forControlEvents:UIControlEventTouchUpInside];
    [mainMenu.user addGestureRecognizer:_userViewTap];
    [mainMenu.feeBackButton addTarget:self action:@selector(showFeeBackVC) forControlEvents:UIControlEventTouchUpInside];
    [mainMenu.babyListButton addTarget:self action:@selector(showBabyListVC) forControlEvents:UIControlEventTouchUpInside];
    [mainMenu.addBabyButton addTarget:self action:@selector(showAddBabyVC:) forControlEvents:UIControlEventTouchUpInside];
    [mainMenu.searchFriendButton addTarget:self action:@selector(showSearchFriendsVC:) forControlEvents:UIControlEventTouchUpInside];
    [mainMenu.myGoodFriendButton addTarget:self action:@selector(showMyGoodFriendListVC) forControlEvents:UIControlEventTouchUpInside];
    [_menuGray addSubview:mainMenu];
    
}
- (void)showSettingVC
{
    [self hideMenuGray:nil];
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}
- (void)showFeeBackVC
{
    [self hideMenuGray:nil];
    FeebackViewController *feeBackVC = [[FeebackViewController alloc] init];
    [self.navigationController pushViewController:feeBackVC animated:YES];
}
- (void)showBabyListVC
{
    [self hideMenuGray:nil];
    BabyListViewController *babyListVC = [[BabyListViewController alloc] init];
    [self.navigationController pushViewController:babyListVC animated:YES];
}
- (void)showMyGoodFriendListVC
{
    [self hideMenuGray:nil];
    MyGoodFriendsListViewController *myFriendListVC = [[MyGoodFriendsListViewController alloc] init];
    [self.navigationController pushViewController:myFriendListVC animated:YES];
}
- (IBAction)showSearchFriendsVC:(id)sender
{
    [self hideMenuGray:nil];
    [ControlCenter pushToSearchFriendVC];
}

- (IBAction)showAddBabyVC:(id)sender
{
    [self hideMenuGray:nil];
    [ControlCenter pushToAddBabyVC];
}
- (IBAction)hideMenuGray:(id)sender
{
     _menuGray.hidden = YES;
     isMenuShown = NO;
}
- (void)showMenu
{
    if (!isMenuShown) {
        _menuGray.hidden = NO;
        isMenuShown = YES;
    }
    else
    {
        _menuGray.hidden = YES;
        isMenuShown = NO;
    }
}
- (IBAction)userViewTouchEvent:(id)sender
{
    UserInfoPageViewController *userInfoVC = [[UserInfoPageViewController alloc] init];
    
    [self.navigationController pushViewController:userInfoVC animated:YES];
}
@end
