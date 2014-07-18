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
#import "MainDropMenu.h"
#import "PersonCenterViewController.h"
#import "SettingViewController.h"
#import "FeeBackViewController.h"
#import "BabyListViewController.h"
#import "MyGoodFriendsListViewController.h"
#import "SearchDynamicViewController.h"
#import "MessageViewController.h"
#import "ShaiWaSquareViewController.h"
#import "DynamicCell.h"
#import "PraiseViewController.h"
#import "DynamicDetailViewController.h"
#import "ReleaseDynamicViewController.h"

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
    [titileImage setUserInteractionEnabled:YES];
    [titileImage addGestureRecognizer:_guoLVTap];
    self.navigationItem.titleView = titileImage;
    UIBarButtonItem * rightItem_1 = [self customBarItem:@"square_yanjing" action:@selector(showSquareVC)];
    UIBarButtonItem * rightItem_2 = [self customBarItem:@"square_pinglun-4" action:@selector(showMsgVC)];
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
    [mainMenu.exitButton addTarget:self action:@selector(quitCurUser) forControlEvents:UIControlEventTouchUpInside];
    [_menuGray addSubview:mainMenu];
    
    isDropMenuShown = NO;
    MainDropMenu *dropMenu =[[MainDropMenu alloc] initWithFrame:CGRectMake(0, 0, _grayDropView.bounds.size.width, 80)];
    
    //[dropMenu.allButton  addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    
    //[dropMenu.onlyMineButton addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    
    //[dropMenu.specialCareButton addTarget:self action:@selector() forControlEvents:UIControlEventTouchUpInside];
    
    [dropMenu.searchDyButton addTarget:self action:@selector(showSearchDyVC) forControlEvents:UIControlEventTouchUpInside];
    [_grayDropView addSubview:dropMenu];
    
    isShareViewShown = NO;
    
    [_dynamicPageTableView clearSeperateLine];
    [_dynamicPageTableView registerNibWithName:@"DynamicCell" reuseIdentifier:@"Cell"];
    
    if ([OSHelper iOS7]) {
        _releaseBtn.frame = CGRectMake(_dynamicPageTableView.bounds.size.width-60, _dynamicPageTableView.bounds.size.height-50 , 44, 46);
    }
    else
    {
    _releaseBtn.frame = CGRectMake(_dynamicPageTableView.bounds.size.width-60, [UIScreen mainScreen].bounds.size.height-50 , 44, 46);
    }
}



#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    [dynamicCell.praiseUserFirstBtn addTarget:self action:@selector(showPraiseListVC) forControlEvents:UIControlEventTouchUpInside];
    [dynamicCell.praiseUserSecondBtn addTarget:self action:@selector(showPraiseListVC) forControlEvents:UIControlEventTouchUpInside];
    [dynamicCell.praiseUserThirdBtn addTarget:self action:@selector(showPraiseListVC) forControlEvents:UIControlEventTouchUpInside];
    [dynamicCell.moreBtn addTarget:self action:@selector(showShareGrayView) forControlEvents:UIControlEventTouchUpInside];
    /*
     // 取当前section，设置单元格显示内容。
     NSInteger section = indexPath.section;
     // 获取这个分组的省份名称，再根据省份名称获得这个省份的城市列表。
     NSString *sectionType = [sectionArr objectAtIndex:section];
     NSArray *list = [babyList objectForKey:sectionType];
     [list objectAtIndex:indexPath.row];
     */
    //babyListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    babyListCell.babyImage.image = [UIImage imageNamed:@""];
    //    babyListCell.babyNameLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babyOldLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babySexImage.image = [UIImage imageNamed:@""];
    
    return dynamicCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] init];
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
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
- (void)quitCurUser
{
    [self hideMenuGray:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
{   [self hideGrayDropView:nil];
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
    [self hideMenuGray:nil];
    PersonCenterViewController *personCenterVC = [[PersonCenterViewController alloc] init];
    [self.navigationController pushViewController:personCenterVC animated:YES];
}
- (IBAction)hideGrayDropView:(id)sender
{
    _grayDropView.hidden = YES;
    isDropMenuShown = NO;
}
- (IBAction)showGrayDropV:(id)sender
{
    [self hideMenuGray:nil];
    if (!isDropMenuShown) {
        _grayDropView.hidden = NO;
        isDropMenuShown = YES;
    }
    else
    {
        _grayDropView.hidden = YES;
        isDropMenuShown = NO;
    }
}

- (IBAction)showSquaresVC:(id)sender
{
    [self showSquareVC];
}
- (void)showSearchDyVC
{
    [self hideGrayDropView:nil];
    SearchDynamicViewController *searchDyVC = [[SearchDynamicViewController alloc] init];
    [self.navigationController pushViewController:searchDyVC animated:YES];
}
- (void)showMsgVC
{
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
}
- (void)showSquareVC
{
    ShaiWaSquareViewController *squareVC = [[ShaiWaSquareViewController alloc] init];
    [self.navigationController pushViewController:squareVC animated:YES];
}

- (void)showPraiseListVC
{
    PraiseViewController *praiseListVC = [[PraiseViewController alloc] init];
    [self.navigationController pushViewController:praiseListVC animated:YES];
}

- (void)showShareGrayView
{
    if (!isShareViewShown) {
        _grayShareView.hidden = NO;
        isShareViewShown = YES;
    }
    else
    {
        _grayShareView.hidden = YES;
        isShareViewShown = NO;
    }
}
- (IBAction)hideGayShareV:(id)sender
{
    _grayShareView.hidden = YES;
    isShareViewShown = NO;
}
- (IBAction)showReleaseVC:(id)sender
{
    ReleaseDynamicViewController *releaseVC = [[ReleaseDynamicViewController alloc] init];
    [self.navigationController pushViewController:releaseVC animated:YES];
}
@end
