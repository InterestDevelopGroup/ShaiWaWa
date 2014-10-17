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
#import "AudioView.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareManager.h"
#import "SDImageCache.h"
#import "BBBadgeBarButtonItem.h"
#import "FriendHomeViewController.h"
@import MediaPlayer;
@import QuartzCore;
typedef enum{
    All_Record,
    Baby_Record,
    Special_Record,
    Keyword_Recrod
}Record_Type;
@interface ChooseModeViewController ()<UIActionSheetDelegate>
{
    ShareView *sv;
    SearchDynamicViewController *searchDyVC;
}
@property (nonatomic,strong) MJRefreshHeaderView * refreshHeaderView;
@property (nonatomic,assign) Record_Type recordType;
@property (nonatomic,assign) int currentOffset;
@property (nonatomic,strong) NSString * keyword;
@property (nonatomic,strong) BabyRecord * selectedRecrod;
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
        _isNeedRefresh = YES;
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
    
    /*
    if (_isNeedRefresh) {
        [self.dynamicPageTableView headerBeginRefreshing];
    }
    */
    
    [self getNewMessages];
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

    if([OSHelper iOS7])
    {
        [_leftButton_1 setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
        [_leftButton_2 setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    }
    
    _leftButton_1.userInteractionEnabled = NO;
    _leftButton_2.userInteractionEnabled = NO;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu)];
    _itemView.userInteractionEnabled = YES;
    [_itemView addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:_itemView];
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
    
    __weak ChooseModeViewController * weakSelf = self;
    [sv setDeleteBlock:^(){
        
        weakSelf.grayShareView.hidden = YES;
        isShareViewShown = NO;
        [weakSelf deleteRecord:weakSelf.selectedRecrod];
    }];

    [sv setCollectionBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        isShareViewShown = NO;
        [weakSelf collectionRecord:weakSelf.selectedRecrod];
    }];
    
    [sv setReportBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        isShareViewShown = NO;
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情",@"反动",@"敏感话题",@"其他", nil];
        [actionSheet showInView:weakSelf.view];
        actionSheet = nil;
        
    }];
    
    
    [sv setWeiXinBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeWeixiSession babyRecord:weakSelf.selectedRecrod];
    }];
    
    [sv setWeiXinCycleBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeWeixiTimeline babyRecord:weakSelf.selectedRecrod];
    }];
    
    [sv setQzoneBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeQQSpace babyRecord:weakSelf.selectedRecrod];
    }];
    
    [sv setXinLanWbBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeSinaWeibo babyRecord:weakSelf.selectedRecrod];
    }];
    [_shareView addSubview:sv];
}


- (void)shareWityType:(ShareType)type babyRecord:(BabyRecord *)babyRecord
{
    if(babyRecord == nil) return;
    
    if(babyRecord.video != nil && [babyRecord.video length] != 0)
    {
        UIImage * image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:babyRecord.video];
        [[ShareManager sharePlatform] shareWithType:type withContent:babyRecord.content withImage:image];
    }
    else if([babyRecord.images count] > 0)
    {
        [[ShareManager sharePlatform] shareWithType:type withContent:babyRecord.content withImagePath:babyRecord.images[0]];
    }
    else
    {
        [[ShareManager sharePlatform] shareWithType:type withContent:babyRecord.content withImage:nil];
    }
}

- (void)deleteRecord:(BabyRecord *)babyRecord
{
    if(babyRecord == nil) return;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] deleteRecord:@{@"uid":users.uid,@"rid":babyRecord.rid} completionBlock:^(id object) {
        if([dyArray containsObject:babyRecord])
        {
            [dyArray removeObject:babyRecord];
            [_dynamicPageTableView reloadData];
        }
        [SVProgressHUD showSuccessWithStatus:@"删除成功."];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"删除失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


- (void)collectionRecord:(BabyRecord *)babyRecord
{
    if(babyRecord == nil) return;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] addFavorite:@{@"uid":users.uid,@"rid":babyRecord.rid} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"收藏成功."];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"收藏失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];

    }];
}

- (void)reportRecord:(BabyRecord *)babyRecord type:(NSString *)type
{
    if(babyRecord == nil) return;
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] addReport:@{@"uid":users.uid,@"rid":babyRecord.rid,@"type":type,@"remark":@"举报动态"} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"举报成功."];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"举报失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
        
    }];
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

#pragma mark - 点赞按钮
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
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[HttpService sharedInstance] cancelLike:@{@"rid":record.rid,@"uid":users.uid} completionBlock:^(id object) {
            
            [SVProgressHUD showSuccessWithStatus:@"取消赞成功."];
            record.is_like = @"0";
            record.like_count = [NSString stringWithFormat:@"%i",[record.like_count intValue] - 1];
            //取出宝宝被点赞的前三个
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:record.top_3_likes];
            for (NSDictionary *dict in record.top_3_likes) {
                if ([dict[@"uid"] isEqualToString:users.uid]) {
                    [tempArr removeObject:dict];
                }
            }
            record.top_3_likes = (NSArray *)tempArr;
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
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
        [[HttpService sharedInstance] addLike:@{@"rid":record.rid,@"uid":users.uid} completionBlock:^(id object) {
            
            [SVProgressHUD showSuccessWithStatus:@"谢谢您的参与."];
            record.is_like = @"1";
            record.like_count = [NSString stringWithFormat:@"%i",[record.like_count intValue] + 1];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:[record.top_3_likes count] + 1];
            [tempArr addObjectsFromArray:record.top_3_likes];
            //生成一个字典
            NSMutableDictionary *zanDict = [@{} mutableCopy];
            zanDict[@"uid"] = users.uid;
            zanDict[@"avatar"] = users.avatar == nil ? @"" : users.avatar;
            zanDict[@"username"] = @"";
            zanDict[@"rid"] = @"";
            zanDict[@"add_time"] = @"";
            [tempArr insertObject:zanDict atIndex:0];
            record.top_3_likes = (NSArray *)tempArr;
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
    
    [_leftButton_1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_leftButton_2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    if([OSHelper iOS7])
    {
        [_leftButton_1 setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
        [_leftButton_2 setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
    }
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
    
    //判断是否显示，如果显示则调整按钮的位置
    if(isMenuShown)
    {
        [_leftButton_1 setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
        [_leftButton_2 setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];

        if([OSHelper iOS7])
        {
            [_leftButton_1 setImageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
            [_leftButton_2 setImageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
        }
    }
    else
    {
        [_leftButton_1 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_leftButton_2 setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        if([OSHelper iOS7])
        {
            [_leftButton_1 setImageEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
            [_leftButton_2 setImageEdgeInsets:UIEdgeInsetsMake(0, -40, 0, 0)];
        }
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
    self.selectedRecrod = record;
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
    vc.parentCtrl = self;
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

- (void)showHomePage:(UITapGestureRecognizer *)gesture
{
    
    if(![gesture.view isKindOfClass:[UILabel class]])
    {
        return ;
    }
    
    UILabel * label = (UILabel *)gesture.view;
    DynamicCell * cell ;
    if([label.superview.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)label.superview.superview.superview.superview;
    }
    else if ([label.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)label.superview.superview.superview;
    }
    else
    {
        cell = (DynamicCell *)label.superview.superview;
    }
    
    NSIndexPath * indexPath = [_dynamicPageTableView indexPathForCell:cell];
    BabyRecord * record = [dyArray objectAtIndex:indexPath.row];
    if([record.uid isEqualToString:users.uid])
    {
        PersonCenterViewController * vc = [[PersonCenterViewController alloc] initWithNibName:nil bundle:nil];
        [self push:vc];
        vc = nil;
    }
    else
    {
        FriendHomeViewController * vc = [[FriendHomeViewController alloc] initWithNibName:nil bundle:nil];
        vc.friendId = record.uid;
        [self push:vc];
        vc = nil;
    }
    
}

#pragma mark 获取消息数量
- (void)getNewMessages
{
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getSystemNotification:@{@"receive_uid":user.uid,@"offset":@"0", @"pagesize":@"100000",@"status":@"0"} completionBlock:^(id object)
     {
//         if([object count] > 0)
//         {
             UIBarButtonItem * rightItem_1 = [self customBarItem:@"square_yanjing" action:@selector(showSquareVC)];
             UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
             btn.frame = CGRectMake(0, 0, 32, 22);
             [btn setImage:[UIImage imageNamed:@"square_pinglun-4"] forState:UIControlStateNormal];
             [btn addTarget:self action:@selector(showMsgVC) forControlEvents:UIControlEventTouchUpInside];
             BBBadgeBarButtonItem * rightItem_2 = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:btn];
             rightItem_2.badgeValue = [NSString stringWithFormat:@"%i",[object count]];
             rightItem_2.badgeOriginX = 20;
             rightItem_2.shouldAnimateBadge = YES;
             //UIBarButtonItem * rightItem_2 = [self customBarItem:@"square_pinglun-4" action:@selector(showMsgVC)];
             self.navigationItem.rightBarButtonItems = @[rightItem_2,rightItem_1];
//         }
         
     } failureBlock:^(NSError *error, NSString *responseString) {

         NSString * msg = responseString;
         if (error) {
             msg = NSLocalizedString(@"LoadError", nil);
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
        _releaseBtn.hidden = YES;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        //NSLog(@"ScrollUp now");
        
    }
    else if (_lastPosition - currentPostion > 280)
    {
        _lastPosition = currentPostion;
        _releaseBtn.hidden = NO;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        //NSLog(@"ScrollDown now");
    }
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dyArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BabyRecord * babyRecord = [dyArray objectAtIndex:indexPath.row];
    float height = 340.0f;
    if([babyRecord.images count] == 0 && (babyRecord.video == nil || [babyRecord.video length] == 0))
    {
        height -= 143;
    }
    
    /*
    if(babyRecord.address == nil || [babyRecord.address length] == 0)
    {
        height -= 17;
    }
    */
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    BabyRecord * recrod = [dyArray objectAtIndex:indexPath.row];
    dynamicCell.addressLabel.text = recrod.address;
    if(recrod.address == nil || [recrod.address length] == 0)
    {
        dynamicCell.locationImageView.hidden = YES;
    }
    else
    {
        dynamicCell.locationImageView.hidden = NO;
    }
    //dynamicCell.dyContentTextView.text = recrod.content;
    dynamicCell.dyContentTextView.attributedText = [NSStringUtil makeTopicString:recrod.content];
    [dynamicCell.babyAvatarImageView sd_setImageWithURL:[NSURL URLWithString:recrod.avatar] placeholderImage:Default_Avatar];
    dynamicCell.babyBirthdayLabel.text = [NSStringUtil calculateAge:recrod.birthday];
    
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
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHomePage:)];
    [dynamicCell.whoLabel addGestureRecognizer:tapGesture];
    dynamicCell.whoLabel.userInteractionEnabled = YES;
    tapGesture = nil;
    
    //添加头像点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBabyHomePage:)];
    dynamicCell.babyAvatarImageView.userInteractionEnabled = YES;
    [dynamicCell.babyAvatarImageView addGestureRecognizer:tap];
    tap = nil;
    
    dynamicCell.babyNameLabel.text = recrod.baby_nickname;
    if([recrod.baby_alias length] != 0)
    {
        dynamicCell.babyNameLabel.text = recrod.baby_alias;
    }
    
    [dynamicCell.babyNameLabel addGestureRecognizer:[[UIGestureRecognizer alloc] initWithTarget:self action:@selector(showBabyHomePage:)]];
    [dynamicCell.zanButton setTitle:recrod.like_count forState:UIControlStateNormal];
    [dynamicCell.zanButton setTitle:recrod.like_count forState:UIControlStateSelected];
    [dynamicCell.commentBtn setTitle:recrod.comment_count forState:UIControlStateNormal];
    dynamicCell.commentBtn.userInteractionEnabled = NO;
    [dynamicCell.zanButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    if([recrod.is_like isEqualToString:@"1"])
    {
        dynamicCell.zanButton.selected = YES;
    }
    else
    {
        dynamicCell.zanButton.selected = NO;
    }
    
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
        [dynamicCell.praiseUserFirstBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
        [dynamicCell.praiseUserFirstBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
        if([recrod.top_3_likes count] == 1)
        {
            dynamicCell.praiseUserSecondBtn.hidden = YES;
            dynamicCell.praiseUserThirdBtn.hidden = YES;
        }
        
        if([recrod.top_3_likes count] > 1)
        {
            dynamicCell.praiseUserSecondBtn.hidden = NO;
            userDic = recrod.top_3_likes[1];
            [dynamicCell.praiseUserSecondBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
            [dynamicCell.praiseUserSecondBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if([recrod.top_3_likes count] > 2)
        {
            dynamicCell.praiseUserThirdBtn.hidden = NO;
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
        dynamicCell.scrollView.hidden = NO;
        imageView.hidden = NO;
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
                ImageDisplayView * displayView = [[ImageDisplayView alloc] initWithFrame:self.navigationController.view.bounds withPath:path withAllImages:recrod.images];
                [self.navigationController.view addSubview:displayView];
                [displayView show];
            };
            [imageView setCloseHidden];
            dynamicCell.scrollView.hidden = NO;
            imageView.hidden = NO;
            [dynamicCell.scrollView addSubview:imageView];
            imageView = nil;
        }
        [dynamicCell.scrollView setContentSize:CGSizeMake([recrod.images count] * width, CGRectGetHeight(dynamicCell.scrollView.bounds))];
        
    }
    else
    {
        /*
        PublishImageView * imageView = [[PublishImageView alloc] initWithFrame:dynamicCell.scrollView.bounds withPath:nil];
        [imageView setCloseHidden];
        [dynamicCell.scrollView addSubview:imageView];
        imageView.hidden = YES;
        imageView = nil;
        */
        dynamicCell.scrollView.hidden = YES;
    
    }
    
    if([recrod.images count] == 0 && (recrod.video == nil || [recrod.video length] == 0))
    {
        CGRect detailRect = dynamicCell.detailView.frame;
        detailRect.origin.y = 68;
        dynamicCell.detailView.frame = detailRect;
        
        CGRect bgRect = dynamicCell.bgImageView.frame;
        bgRect.size.height = 184;
        dynamicCell.bgImageView.frame = bgRect;
    }
    else
    {
        CGRect detailRect = dynamicCell.detailView.frame;
        detailRect.origin.y = 210;
        dynamicCell.detailView.frame = detailRect;
        
        CGRect bgRect = dynamicCell.bgImageView.frame;
        bgRect.size.height = 327;
        dynamicCell.bgImageView.frame = bgRect;

    }
    
    dynamicCell.releaseTimeLabel.text = [NSStringUtil calculateTime:recrod.add_time];
    
    [[dynamicCell.contentView viewWithTag:20000] removeFromSuperview];
    if(recrod.audio != nil && [recrod.audio length] > 0)
    {
        CGRect rect = CGRectMake(123, 175, 82, 50);
        if([recrod.images count] == 0 && (recrod.video == nil || [recrod.video length] == 0))
        {
            rect = CGRectMake(123, 35, 82, 50);
        }
        
        AudioView * audioView = [[AudioView alloc] initWithFrame:rect withPath:recrod.audio];
        audioView.tag = 20000;
        [audioView setCloseHidden];
        [dynamicCell.contentView addSubview:audioView];
    }
    
    
    
    [dynamicCell layoutSubviews];
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

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    BabyRecord * record = dyArray[indexPath.row];
//    if (record.images.count == 0) {
//        return 340.0 - 134.0;
//    }else{
//        return 340.0;
//    }
//}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%i",buttonIndex);
    if(buttonIndex== actionSheet.cancelButtonIndex)
    {
        _selectedRecrod = nil;
        return ;
    }
    
    NSString * type = [NSString stringWithFormat:@"%i",buttonIndex + 1];
    
    [self reportRecord:_selectedRecrod type:type];
}


@end
