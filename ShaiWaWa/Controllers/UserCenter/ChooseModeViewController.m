//
//  ChooseModeViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-5.
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
#import "PublishRecordViewController.h"
#import "LoginViewController.h"
#import "DynamicCell.h"
#import "PraiseViewController.h"
#import "DynamicDetailViewController.h"
#import "TopicListOfDynamic.h"
#import "UserDefault.h"
#import "ShareView.h"
#import "BabyRecord.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "BabyInfo.h"
#import "AppMacros.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "NSStringUtil.h"
#import "PublishImageView.h"
#import "ImageDisplayView.h"
#import "PraiseViewController.h"
#import "BabyHomePageViewController.h"
@import MediaPlayer;
@import QuartzCore;
typedef enum{
    All_Record,
    Baby_Record,
    Special_Record,
    Keyword_Recrod
}Record_Type;
@interface ChooseModeViewController ()
{
    ShareView *sv;
    SearchDynamicViewController *searchDyVC;
}
@property (nonatomic,strong) MJRefreshHeaderView * refreshHeaderView;
@property (nonatomic,assign) Record_Type recordType;
@property (nonatomic,assign) int currentOffset;
@property (nonatomic,strong) NSString * keyword;
@property (nonatomic,strong) NSIndexPath * selectedIndexPath;
@end

@implementation ChooseModeViewController
@synthesize dyArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _recordType = All_Record;
        users = [[UserDefault sharedInstance] userInfo];
        _currentOffset = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    dyArray = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    users = [[UserDefault sharedInstance] userInfo];
    //判断是否有宝宝和动态
    [self isNoBabyAndFriend];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods
- (void)initUI
{
    UIBarButtonItem * leftItem;
    if ([OSHelper iOS7])
    {
        leftItem = [self customBarItem:@"square_cebinlan" action:@selector(showMenu) size:CGSizeMake(40, 30) imageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];

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

    //左边菜单
    [self configLeftMenu];
    //顶部菜单
    [self configTopMenu];
    //分享视图
    [self configShareView];
    

    [self configTableView];
    
    //判断是否有宝宝和动态
    [self isNoBabyAndFriend];

    
}

//配置tableview
- (void)configTableView
{
    [_dynamicPageTableView clearSeperateLine];
    [_dynamicPageTableView registerNibWithName:@"DynamicCell" reuseIdentifier:@"Cell"];
    
    /*
    if ([OSHelper iOS7]) {
        _releaseBtn.frame = CGRectMake(_dynamicPageTableView.bounds.size.width-60, _dynamicPageTableView.bounds.size.height-100 , 44, 46);
    }
    else
    {
        if ([UIScreen mainScreen].bounds.size.height < 490) {
            _releaseBtn.frame = CGRectMake(_dynamicPageTableView.bounds.size.width-60, [UIScreen mainScreen].bounds.size.height-150 , 44, 46);
        }
        else
        {
            _releaseBtn.frame = CGRectMake(_dynamicPageTableView.bounds.size.width-60, [UIScreen mainScreen].bounds.size.height-50 , 44, 46);
        }
    }
    */
    
    [_dynamicPageTableView addHeaderWithTarget:self action:@selector(refreshData:)];
    [_dynamicPageTableView setHeaderRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    [_dynamicPageTableView addFooterWithTarget:self action:@selector(loadMoreData)];
    [_dynamicPageTableView setFooterPullToRefreshText:NSLocalizedString(@"PullTOLoad", nil)];
    [_dynamicPageTableView setFooterRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    
    if([users.baby_count intValue] != 0 || [users.record_count intValue] != 0)
    {
        [_dynamicPageTableView headerBeginRefreshing];
    }

}


- (void)configLeftMenu
{
    isMenuShown = NO;
    MainMenu *mainMenu = [[MainMenu alloc] initWithFrame:CGRectMake(0, 0, 240, 390)];
    mainMenu.userInteractionEnabled = YES;
    //设置菜单功能
    [mainMenu setSetBtnBlock:^(UIButton * btn)
     {
         [self showSettingVC];
         
     }];
    
    [mainMenu setSearchFriendBtnBlock:^(UIButton * btn)
     {
         [self showSearchFriendsVC:btn];
         
     }];
    
    [mainMenu setExitBtnBlock:^(UIButton * btn)
     {
         [self quitCurUser];
         
     }];
    
    [mainMenu setFeeBackBtnBlock:^(UIButton * btn)
     {
         [self showFeeBackVC];
         
     }];
    
    [mainMenu setBabyListBtnBlock:^(UIButton * btn)
     {
         [self showBabyListVC];
         
     }];
    
    [mainMenu setAddBabyBtnBlock:^(UIButton * btn)
     {
         [self showAddBabyVC:btn];
         
     }];
    
    [mainMenu setMyGoodFriendBtnBlock:^(UIButton * btn)
     {
         [self showMyGoodFriendListVC];
         
     }];
    
    [mainMenu setUserVBlock:^(UIView * viewer)
     {
         [self userViewTouchEvent:viewer];
         
     }];
    
    
    mainMenu.nameLabel.text = users.username;
    [mainMenu.touXiangImgView sd_setImageWithURL:[NSURL URLWithString:users.avatar] placeholderImage:[UIImage imageNamed:@"user_touxiang"]];
    [_mainAddView addSubview:mainMenu];
}

- (void)configTopMenu
{
    isDropMenuShown = NO;
    MainDropMenu *dropMenu =[[MainDropMenu alloc] initWithFrame:CGRectMake(0, 0, _grayDropView.bounds.size.width, 80)];
    
    [dropMenu.allButton  addTarget:self action:@selector(showAllDyListAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [dropMenu.onlyMineButton addTarget:self action:@selector(showOnlyMyBabyDyListAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [dropMenu.specialCareButton addTarget:self action:@selector(showSpecialCareDyListAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [dropMenu.searchDyButton addTarget:self action:@selector(showSearchDyVC) forControlEvents:UIControlEventTouchUpInside];
    [_grayDropView addSubview:dropMenu];
}


- (void)configShareView
{
    isShareViewShown = NO;
    sv = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
    
    [sv setDeleteBlock:^(){
        
    }];

    [sv setCollectionBlock:^(){
        
    }];
    
    
    [_shareView addSubview:sv];
}


//显示所有动态
- (void)showAllDyListAction:(id)sender
{
    _currentOffset = 0;
    _recordType = All_Record;
    [self hideGrayDropView:nil];
    [_dynamicPageTableView headerBeginRefreshing];
}

//显示我的宝宝动态
- (void)showOnlyMyBabyDyListAction:(id)sender
{
    _currentOffset = 0;
    _recordType = Baby_Record;
    [self hideGrayDropView:nil];
    [_dynamicPageTableView headerBeginRefreshing];
}

//显示特别关注动态
- (void)showSpecialCareDyListAction:(id)sender
{
    _currentOffset = 0;
    _recordType = Special_Record;
    [self hideGrayDropView:nil];
    [_dynamicPageTableView headerBeginRefreshing];
}

//刷新数据
- (void)refreshData:(UIRefreshControl *)refreshControl
{
    _currentOffset = 0;
    if(_recordType == All_Record)
    {
        [self showAllDyList];
    }
    else if(_recordType == Baby_Record)
    {
        [self showOnlyMyBabyDyList];
    }
    else if(_recordType == Special_Record)
    {
        [self showSpecialCareDyList];
    }
    else if(_recordType == Keyword_Recrod)
    {
        [self searchRecord];
    }
}




//请求所有动态
- (void)showAllDyList
{
    _buttonView.hidden = YES;
    [self hideGrayDropView:nil];
    [[HttpService sharedInstance] getRecordList:@{@"offset":[NSString stringWithFormat:@"%i",_currentOffset], @"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"uid":users.uid} completionBlock:^(id object) {
        [_dynamicPageTableView headerEndRefreshing];
        [_dynamicPageTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            dyArray = object;
        }
        else
        {
            [dyArray addObjectsFromArray:object];
        }
        [_dynamicPageTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoadFinish", nil)];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_dynamicPageTableView headerEndRefreshing];
        [_dynamicPageTableView footerEndRefreshing];

    }];
}

//请求我的宝宝动态
- (void)showOnlyMyBabyDyList
{
    _buttonView.hidden = YES;
    [self hideGrayDropView:nil];
    [[HttpService sharedInstance] getRecordByUserID:@{@"offset":[NSString stringWithFormat:@"%i",_currentOffset], @"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"uid":users.uid} completionBlock:^(id object) {
        [_dynamicPageTableView headerEndRefreshing];
        [_dynamicPageTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            dyArray = (NSMutableArray *)object;
        }
        else
        {
            [dyArray addObjectsFromArray:object];
        }

        [_dynamicPageTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoadFinish", nil)];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error)
        {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_dynamicPageTableView headerEndRefreshing];
        [_dynamicPageTableView footerEndRefreshing];
    }];
    
}

//请求特别关注宝宝动态
- (void)showSpecialCareDyList
{
    _buttonView.hidden = YES;
    [self hideGrayDropView:nil];
    [[HttpService sharedInstance] getRecordByFollow:@{@"offset":[NSString stringWithFormat:@"%i",_currentOffset], @"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"uid":users.uid} completionBlock:^(id object) {
        [_dynamicPageTableView headerEndRefreshing];
        [_dynamicPageTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            dyArray = object;
        }
        else
        {
            [dyArray addObjectsFromArray:object];
        }

        [_dynamicPageTableView reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_dynamicPageTableView headerEndRefreshing];
        [_dynamicPageTableView footerEndRefreshing];
    }];
    
}

//搜索动态
- (void)searchRecord
{
    _buttonView.hidden = YES;
    [self hideGrayDropView:nil];
    [[HttpService sharedInstance] searchRecord:@{@"keyword":_keyword, @"offset":[NSString stringWithFormat:@"%i",_currentOffset], @"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize]} completionBlock:^(id object) {
        [_dynamicPageTableView headerEndRefreshing];
        [_dynamicPageTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            dyArray = object;
        }
        else
        {
            [dyArray addObjectsFromArray:object];
        }
        
        [_dynamicPageTableView reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_dynamicPageTableView headerEndRefreshing];
        [_dynamicPageTableView footerEndRefreshing];
    }];
}


- (void)loadMoreData
{
    _currentOffset = [dyArray count];
    if(_recordType == All_Record)
    {
        [self showAllDyList];
    }
    else if(_recordType == Baby_Record)
    {
        [self showOnlyMyBabyDyList];
    }
    else if(_recordType == Special_Record)
    {
        [self showSpecialCareDyList];
    }

}

- (void)likeAction:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    DynamicCell * cell;

    if([btn.superview.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)btn.superview.superview.superview.superview;
    }
    else if([btn.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)btn.superview.superview.superview;
    }
    else
    {
        cell = (DynamicCell *)btn.superview.superview;
    }
    
    
    NSIndexPath * indexPath = [_dynamicPageTableView indexPathForCell:cell];
    BabyRecord * record = dyArray[indexPath.row];
    
    if([record.is_like isEqualToString:@"1"])
    {
        //取消赞
        [[HttpService sharedInstance] cancelLike:@{@"rid":record.rid,@"uid":users.uid} completionBlock:^(id object) {
            
            [SVProgressHUD showSuccessWithStatus:@"取消赞成功."];
            record.is_like = @"0";
            record.like_count = [NSString stringWithFormat:@"%i",[record.like_count intValue] - 1];
            [_dynamicPageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } failureBlock:^(NSError *error, NSString *responseString) {
            NSString * msg = responseString;
            if(error)
            {
                msg = @"请求失败";
            }
            [SVProgressHUD showErrorWithStatus:msg];
        }];

    }
    else
    {
        [[HttpService sharedInstance] addLike:@{@"rid":record.rid,@"uid":users.uid} completionBlock:^(id object) {
            
            [SVProgressHUD showSuccessWithStatus:@"谢谢您的参与."];
            record.is_like = @"1";
            record.like_count = [NSString stringWithFormat:@"%i",[record.like_count intValue] + 1];
            [_dynamicPageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } failureBlock:^(NSError *error, NSString *responseString) {
            NSString * msg = responseString;
            if(error)
            {
                msg = @"请求失败";
            }
            [SVProgressHUD showErrorWithStatus:msg];
        }];

    }
    
}



#pragma mark - Action Methods
//设置页面
- (void)showSettingVC
{
    [self hideMenuGray:nil];
    SettingViewController *settingVC = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

//意见反馈
- (void)showFeeBackVC
{
    [self hideMenuGray:nil];
    FeebackViewController *feeBackVC = [[FeebackViewController alloc] init];
    [self.navigationController pushViewController:feeBackVC animated:YES];
}

//宝宝列表
- (void)showBabyListVC
{
    [self hideMenuGray:nil];
    BabyListViewController *babyListVC = [[BabyListViewController alloc] init];
    [self.navigationController pushViewController:babyListVC animated:YES];
}

//我的好友列表
- (void)showMyGoodFriendListVC
{
    [self hideMenuGray:nil];
    MyGoodFriendsListViewController *myFriendListVC = [[MyGoodFriendsListViewController alloc] init];
    [self.navigationController pushViewController:myFriendListVC animated:YES];
}

//退出当前用户
- (void)quitCurUser
{
    [self hideMenuGray:nil];
    [[UserDefault sharedInstance] setUserInfo:nil];
    if([self.navigationController.viewControllers count] > 1)
    {
        [self popToRoot];
    }
    else
    {
        LoginViewController * vc = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
        self.navigationController.viewControllers = @[vc];
        vc = nil;
    }
}

//搜索朋友
- (IBAction)showSearchFriendsVC:(id)sender
{
    [self hideMenuGray:nil];
    [ControlCenter pushToSearchFriendVC];
}

//添加宝宝
- (IBAction)showAddBabyVC:(id)sender
{
    [self hideMenuGray:nil];
    [ControlCenter pushToAddBabyVC];
}


//隐藏overlay
- (IBAction)hideMenuGray:(id)sender
{
    _menuGray.hidden = YES;
    isMenuShown = NO;
}

//显示菜单
- (void)showMenu
{
    
    [self hideGrayDropView:nil];
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
    PersonCenterViewController *personCenterVC = [[PersonCenterViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:personCenterVC animated:YES];
    personCenterVC = nil;
}

//隐藏
- (IBAction)hideGrayDropView:(id)sender
{
    _grayDropView.hidden = YES;
    isDropMenuShown = NO;
}

//显示overlay
- (IBAction)showGrayDropV:(id)sender
{
    [self hideMenuGray:nil];
    [self hideGayShareV:nil];
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

//显示广场
- (IBAction)showSquaresVC:(id)sender
{
    [self showSquareVC];
}

//显示搜索页面
- (void)showSearchDyVC
{
    [self hideGrayDropView:nil];
    __weak ChooseModeViewController *lchoose = self;
    searchDyVC = [[SearchDynamicViewController alloc] initWithNibName:nil bundle:nil];
    [searchDyVC setSearchBlock:^(NSString * keyword){
        lchoose.currentOffset = 0;
        lchoose.keyword = keyword;
        lchoose.recordType = Keyword_Recrod;
        [lchoose.dynamicPageTableView headerBeginRefreshing];
    }];
    
    [self.navigationController pushViewController:searchDyVC animated:YES];
}


- (void)showMsgVC
{
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    [self.navigationController pushViewController:messageVC animated:YES];
    messageVC = nil;
}



- (void)showSquareVC
{
    
    ShaiWaSquareViewController *squareVC = [[ShaiWaSquareViewController alloc] init];
    [self.navigationController pushViewController:squareVC animated:YES];
}

- (void)showPraiseListVC:(UIButton *)sender
{
    
    UIButton * btn = (UIButton *)sender;
    DynamicCell * cell;
    
    if([btn.superview.superview.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)btn.superview.superview.superview.superview.superview;
    }
    else if([btn.superview.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)btn.superview.superview.superview.superview;
    }
    else
    {
        cell = (DynamicCell *)btn.superview.superview.superview;
    }
    NSIndexPath * indexPath = [_dynamicPageTableView indexPathForCell:cell];
    BabyRecord * record = dyArray[indexPath.row];

    
    PraiseViewController *praiseListVC = [[PraiseViewController alloc] init];
    praiseListVC.record = record;
    [self.navigationController pushViewController:praiseListVC animated:YES];
}

- (void)showShareGrayView:(UIButton *)button
{
    
    UIButton * btn = (UIButton *)button;
    DynamicCell * cell;
    
    if([btn.superview.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)btn.superview.superview.superview.superview;
    }
    else if([btn.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)btn.superview.superview.superview;
    }
    else
    {
        cell = (DynamicCell *)btn.superview.superview;
    }
    NSIndexPath * indexPath = [_dynamicPageTableView indexPathForCell:cell];
    BabyRecord * record = dyArray[indexPath.row];
    
    if([record.uid isEqualToString:users.uid])
    {
        [sv showDelBtn];
    }
    else
    {
        [sv hideDelBtn];
    }
    
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
    
    PublishRecordViewController * vc = [[PublishRecordViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
    
}


- (void)showTopicOfDyVC
{
    TopicListOfDynamic *topicListOfDyVC = [[TopicListOfDynamic alloc] init];
    [self.navigationController pushViewController:topicListOfDyVC animated:YES];
}

- (void)isNoBabyAndFriend
{
    if([users.baby_count intValue] == 0 && [users.record_count intValue] == 0)
    {
        _buttonView.hidden = NO;
        _releaseBtn.hidden = YES;
    }
    else
    {
        _buttonView.hidden = YES;
        _releaseBtn.hidden = NO;
    }
}

- (void)showTopicDynamic:(UIButton *)sender
{
    NSString * topic = [sender titleForState:UIControlStateNormal];
    TopicListOfDynamic * vc = [[TopicListOfDynamic alloc] initWithNibName:nil bundle:nil];
    vc.topic = topic;
    [self push:vc];
    vc = nil;
}


- (void)showBabyHomePage:(UITapGestureRecognizer *)gesture
{
    if(![gesture.view isKindOfClass:[UIImageView class]])
    {
        return ;
    }
    
    UIImageView * imageView = (UIImageView *)gesture.view;
    DynamicCell * cell ;
    if([imageView.superview.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)imageView.superview.superview.superview.superview;
    }
    else if ([imageView.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)imageView.superview.superview.superview;
    }
    else
    {
        cell = (DynamicCell *)imageView.superview.superview;
    }
    
    NSIndexPath * indexPath = [_dynamicPageTableView indexPathForCell:cell];
    BabyRecord * record = [dyArray objectAtIndex:indexPath.row];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpService sharedInstance] getBabyInfo:@{@"baby_id":record.baby_id} completionBlock:^(id object) {
        [SVProgressHUD dismiss];
        BabyHomePageViewController * vc = [[BabyHomePageViewController alloc] initWithNibName:nil bundle:nil];
        vc.babyInfo = object;
        [self push:vc];
        vc = nil;
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"加载失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


#pragma mark -  UIScrollViewDelegate Methods
int _lastPosition;    //A variable define in headfile

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 280) {
        _lastPosition = currentPostion;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        //NSLog(@"ScrollUp now");
        
    }
    else if (_lastPosition - currentPostion > 280)
    {
        _lastPosition = currentPostion;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        //NSLog(@"ScrollDown now");
    }
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dyArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    BabyRecord * recrod = [dyArray objectAtIndex:indexPath.row];
    dynamicCell.addressLabel.text = recrod.address;
    //dynamicCell.dyContentTextView.text = recrod.content;
    dynamicCell.dyContentTextView.attributedText = [NSStringUtil makeTopicString:recrod.content];
    [dynamicCell.babyAvatarImageView sd_setImageWithURL:[NSURL URLWithString:recrod.avatar] placeholderImage:Default_Avatar];
    
    NSString * who = recrod.username;
    if([recrod.sex isEqualToString:@"1"])
    {
        who = [NSString stringWithFormat:@"%@(爸爸)",who];
    }
    else if ([recrod.sex isEqualToString:@"2"])
    {
        who = [NSString stringWithFormat:@"%@(妈妈)",who];
    }
    dynamicCell.whoLabel.text = who;
    
    //添加头像点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBabyHomePage:)];
    dynamicCell.babyAvatarImageView.userInteractionEnabled = YES;
    [dynamicCell.babyAvatarImageView addGestureRecognizer:tap];
    tap = nil;
    
    dynamicCell.babyNameLabel.text = recrod.baby_nickname;
    [dynamicCell.zanButton setTitle:recrod.like_count forState:UIControlStateNormal];
    [dynamicCell.commentBtn setTitle:recrod.comment_count forState:UIControlStateNormal];
    [dynamicCell.zanButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [dynamicCell.moreBtn addTarget:self action:@selector(showShareGrayView:) forControlEvents:UIControlEventTouchUpInside];
    
    //显示话题
    NSArray * topics = [NSStringUtil getTopicStringArray:recrod.content];
    if([topics count] > 0)
    {
        dynamicCell.topicView.hidden = NO;
        [[dynamicCell.topicView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        for (int i = 0; i < [topics count]; i++) {
            if(i >= 2)
            {
                break ;
            }
            
            NSString * topic = topics[i];
            CGSize size = [topic sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 0.0)];
            //DDLogInfo(@"%f,%f",size.width,size.height);
            size.width += 10;
            if(size.width >= 65)
            {
                size.width = 65;
            }
            
            UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor colorWithRed:247.0f/255.0f green:249.0/255.0f blue:248.0/255.0 alpha:1.0];
            btn.frame = CGRectMake(i * 65, 0, size.width, 16);
            [btn setTitle:topic forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 3.0f;
            [btn addTarget:self action:@selector(showTopicDynamic:) forControlEvents:UIControlEventTouchUpInside];
            [dynamicCell.topicView addSubview:btn];
            btn = nil;
        }
    }
    else
    {
        dynamicCell.topicView.hidden = YES;
    }

    
    //显示赞用户头像
    if([recrod.top_3_likes count] > 0)
    {
        dynamicCell.likeUserView.hidden = NO;
        NSDictionary * userDic = recrod.top_3_likes[0];
        [dynamicCell.praiseUserFirstBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
        [dynamicCell.praiseUserFirstBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
        
        if([recrod.top_3_likes count] == 1)
        {
            dynamicCell.praiseUserSecondBtn.hidden = YES;
            dynamicCell.praiseUserThirdBtn.hidden = YES;
        }
        
        if([recrod.top_3_likes count] > 1)
        {
            userDic = recrod.top_3_likes[1];
            [dynamicCell.praiseUserSecondBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
            [dynamicCell.praiseUserSecondBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if([recrod.top_3_likes count] > 2)
        {
            userDic = recrod.top_3_likes[2];
            [dynamicCell.praiseUserThirdBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
            [dynamicCell.praiseUserThirdBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else
    {
        dynamicCell.likeUserView.hidden = YES;
    }
    
    
    //删除重用cell原来的图片
    NSArray * scrollSubviews = [dynamicCell.scrollView subviews];
    for(UIView * view in scrollSubviews)
    {
        if([view isKindOfClass:[PublishImageView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    //显示动态图片或者视频
    if(recrod.video != nil && [recrod.video length] != 0)
    {
        PublishImageView * imageView = [[PublishImageView alloc] initWithFrame:dynamicCell.scrollView.bounds withPath:recrod.video];
        imageView.tapBlock = ^(NSString * path){
            
            MPMoviePlayerViewController * player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:recrod.video]];
            player.moviePlayer.shouldAutoplay = YES;
            [player.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
            [player.moviePlayer prepareToPlay];
            [self presentViewController:player animated:YES completion:nil];
            
        };
        [imageView setCloseHidden];
        [dynamicCell.scrollView addSubview:imageView];
        imageView = nil;
    }
    else if([recrod.images count] != 0)
    {
        int count = [recrod.images count];
        if(count > 3)
        {
            count = 3;
        }
        float width = CGRectGetWidth(dynamicCell.scrollView.bounds)/count;
        for(int i = 0; i < [recrod.images count]; i++)
        {
            PublishImageView * imageView = [[PublishImageView alloc] initWithFrame:CGRectMake(i * width, 0, width, CGRectGetHeight(dynamicCell.scrollView.bounds)) withPath:recrod.images[i]];
            imageView.tapBlock = ^(NSString * path){
                ImageDisplayView * displayView = [[ImageDisplayView alloc] initWithFrame:self.navigationController.view.bounds withPath:path];
                [self.navigationController.view addSubview:displayView];
                [displayView show];
            };
            [imageView setCloseHidden];
            [dynamicCell.scrollView addSubview:imageView];
            imageView = nil;
        }
        [dynamicCell.scrollView setContentSize:CGSizeMake([recrod.images count] * width, CGRectGetHeight(dynamicCell.scrollView.bounds))];
        
    }
    else
    {
        PublishImageView * imageView = [[PublishImageView alloc] initWithFrame:dynamicCell.scrollView.bounds withPath:nil];
        [imageView setCloseHidden];
        [dynamicCell.scrollView addSubview:imageView];
        imageView = nil;
    }
    
    return dynamicCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] initWithNibName:nil bundle:nil];
    BabyRecord * record = dyArray[indexPath.row];
    dynamicDetailVC.babyRecord = record;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}




@end
