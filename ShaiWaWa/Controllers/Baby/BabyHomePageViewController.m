//
//  BabyHomePageViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BabyHomePageViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "SummaryCell.h"
#import "BabyHomeDynamicCell.h"
#import "NetCell.h"
#import "PraiseViewController.h"
#import "DynamicDetailViewController.h"
#import "NALLabelsMatrix.h"
#import "AddHeightAndWeightViewController.h"
#import "RemarksViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "InputHelper.h"
#import "AppMacros.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "PublishImageView.h"
#import "BabyRecord.h"
#import "ImageDisplayView.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "NSStringUtil.h"
#import "BabyGrowRecord.h"
#import "PersonCenterViewController.h"
#import "FriendHomeViewController.h"
#import "ShareManager.h"
#import "AudioView.h"
#import "LineChartController.h"
#import "BabyRemark.h"
#import "QNUploadHelper.h"

@import MediaPlayer;
@interface BabyHomePageViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    UITableView *_gridView;   ///身高体重显示的tableView
    NSArray *_growRecordArray; //存放宝宝成长记录的数组
    
    UIImage *_image;
    NSString *_filePath;
}
@property (nonatomic, strong) NSMutableArray *babyPersonalDyArray;
@property (nonatomic, strong) NSString *dyNum;
//@property (nonatomic, strong) NALLabelsMatrix * matrix;
@property (nonatomic, assign) int dyOffset;
@end

@implementation BabyHomePageViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dyOffset = 0;
        _babyPersonalDyArray = [@[] mutableCopy];
        summaryKey = [NSArray arrayWithObjects:@"昵称",@"姓名",@"出生日期",@"性别",@"所在城市",@"出生身高",@"出生体重", nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //获取宝宝的备注信息
    if (!self.isFromRemarkController) {
        //自动刷新
        [_dynamicListTableView headerBeginRefreshing];
        
        //获取宝宝成长记录
        [self getGrowRecords];
    }
    else
    {
        [self getBabyRemarkInfo];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if(isRemarksBtnShown)
    {
        [self showList:nil];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods
- (void)initUI
{
    self.title = _babyInfo.nickname;
    
    [self getBabyRemarkInfo]; //获得宝宝信息，如果获取到，顺便显示备注名称

    //判断宝宝是不是我的，如果不是，头像按钮禁止点击
     UserInfo * user = [[UserDefault sharedInstance] userInfo];
    if(![_babyInfo.uid isEqualToString:user.uid]){_babyAvatarImgView.enabled = NO;}
    
    [self setLeftCusBarItem:@"square_back" action:nil];
    _babyPersonalDyArray = [[NSMutableArray alloc] init];
    if ([OSHelper iOS7])
    {
        UIBarButtonItem * right_doWith = [self customBarItem:@"user_gengduo" action:@selector(showList:) size:CGSizeMake(38, 30) imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
        self.navigationItem.rightBarButtonItem = right_doWith;
        
    }
    else
    {
        UIBarButtonItem * right_doWith = [self customBarItem:@"user_gengduo" action:@selector(showList:)];
        self.navigationItem.rightBarButtonItem = right_doWith;
    }
    remarksBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [remarksBtn setBackgroundColor:[UIColor whiteColor]];
    [remarksBtn setTitle:@"备注信息" forState:UIControlStateNormal];
    [remarksBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    remarksBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    remarksBtn.frame = CGRectMake(self.navigationController.navigationBar.bounds.size.width-90, self.navigationController.navigationBar.bounds.size.height+10, 84, 41);
    [remarksBtn addTarget:self action:@selector(showRemarkVC) forControlEvents:UIControlEventTouchUpInside];
    //[remarksBtn setImage:[UIImage imageNamed:@"remark"] forState:UIControlStateNormal];
    specialCareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [specialCareBtn setBackgroundColor:[UIColor whiteColor]];
    NSString *foucus = nil;
    if ([_babyInfo.is_focus isEqualToString:@"1"]) {
        foucus = @"取消关注";
    }else{
        foucus = @"特别关注";
    }
    
    [specialCareBtn setTitle:foucus forState:UIControlStateNormal];
    
    [self isFocus];

    
    [specialCareBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    specialCareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    specialCareBtn.frame = CGRectMake(self.navigationController.navigationBar.bounds.size.width-90, self.navigationController.navigationBar.bounds.size.height+51, 84, 41);
    [specialCareBtn addTarget:self action:@selector(specialCare) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:_yaoQingbgView];
    isRemarksBtnShown = NO;
    isRightBtnSelected = NO;
    isShareViewShown = NO;
    [self HMSegmentedControlInitMethod];
   
    if ([[UIScreen mainScreen] bounds].size.height < 500)
    {
        _segScrollView.contentSize = CGSizeMake(320*3, _segScrollView.bounds.size.height-100);
    }
    else
    {
        _segScrollView.contentSize = CGSizeMake(320*3, _segScrollView.bounds.size.height);
    }
    
    
    [_summaryTableView registerNibWithName:@"SummaryCell" reuseIdentifier:@"Cell"];
    [_segScrollView addSubview:_summaryView];
    
    [_dynamicListTableView clearSeperateLine];
    [_dynamicListTableView registerNibWithName:@"BabyHomeDynamicCell" reuseIdentifier:@"Celler"];
    _dynamicListView.frame = CGRectMake(320, 0, 320, _segScrollView.bounds.size.height);
    [_segScrollView addSubview:_dynamicListView];
    
    //上拉加载更多
    [_dynamicListTableView addFooterWithCallback:^{
        [self loadRecords];
    }];
    //下拉刷新
    [_dynamicListTableView addHeaderWithCallback:^{
        [self refreshRecords];
    }];

        
    //身高体重
    _heightAndWeightTableView.frame = CGRectMake(320*2, 0, 320, _segScrollView.bounds.size.height);
    [_segScrollView addSubview:_heightAndWeightTableView];
   CGFloat height = 0.0f;
    if ([[UIScreen mainScreen] bounds].size.height < 500)
    {
        height = 170.f;
    }
    else
    {
        height = 250.f;
    }
    UITableView *gridView = [[UITableView alloc] initWithFrame:CGRectMake(10, 45, 300, height)];
    gridView.delegate = self;
    gridView.dataSource = self;
    gridView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_heightAndWeightTableView addSubview:gridView];
    _gridView = gridView;
    [_gridView registerNibWithName:@"NetCell" reuseIdentifier:@"CellID"];
    _gridView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _gridView.showsVerticalScrollIndicator = NO;
    //宝宝出生日期时间选择器
    [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    [_datePicker setMaximumDate:[NSDate date]];
    
    
    UIImage * placeHolder = Boy_Avatar;
    if([_babyInfo.sex isEqualToString:@"2"])
    {
        placeHolder = Girl_Avatar;
    }
    
    if (_babyAvatarImgView.enabled)
    {
        [_babyAvatarImgView sd_setImageWithURL:[NSURL URLWithString:_babyInfo.avatar] forState:UIControlStateNormal placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            if(image)
            {
                [_babyAvatarImgView setImage:[image ellipseImageWithDefaultSetting]  forState:UIControlStateNormal];
            }
            
        }];
    }
    else
    {
        
        [_babyAvatarImgView sd_setImageWithURL:[NSURL URLWithString:_babyInfo.avatar] forState:UIControlStateNormal placeholderImage:placeHolder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image)
            {
                [_babyAvatarImgView setImage:[image ellipseImageWithDefaultSetting]  forState:UIControlStateNormal];
                [_babyAvatarImgView setImage:[image ellipseImageWithDefaultSetting] forState:UIControlStateDisabled];
            }

        }];
    }
    
    //获取爸爸或者妈妈头像
    if(_babyInfo.fid != nil && ![_babyInfo.fid isEqualToString:@"0"])
    {
        [self getUserInfo:@"1" withUid:_babyInfo.fid];
    }
    else
    {
        //_dadLabel.text = @"邀请";
        _dadLabel.hidden = YES;
        _dadButton.titleLabel.numberOfLines = 2;
        [_dadButton setTitle:@"邀请\n爸爸" forState:UIControlStateNormal];
        [_dadButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    }
    
    if(_babyInfo.mid != nil && ![_babyInfo.mid isEqualToString:@"0"])
    {
        [self getUserInfo:@"2" withUid:_babyInfo.mid];
    }
    else
    {
        //_monLabel.text = @"邀请";
        _monLabel.hidden = YES;
        _monButton.titleLabel.numberOfLines = 2;
        [_monButton setTitle:@"邀请\n妈妈" forState:UIControlStateNormal];
        [_monButton setTitleColor: [UIColor darkTextColor] forState:UIControlStateNormal];
    }

    
    if([user.uid isEqualToString:_babyInfo.fid] || [user.uid isEqualToString:_babyInfo.mid])
    {
        _addButton.hidden = NO;
    }else
    {
        _addButton.hidden = YES;
    }
    
    //修改爸爸妈妈头像按钮风格
    _dadButton.layer.cornerRadius = 8 ;
    _dadButton.layer.masksToBounds = YES;
    _dadButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _dadButton.layer.borderWidth = 1.0;
    _monButton.layer.cornerRadius = 8 ;
    _monButton.layer.masksToBounds = YES;
    _monButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    _monButton.layer.borderWidth = 1.0;
}

- (void)getBabyRemarkInfo
{
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    
    [[HttpService sharedInstance] getBabyRemark:@{@"uid":users.uid,@"baby_id":_babyInfo.baby_id} completionBlock:^(id object) {
        _remark = (BabyRemark *)object;
        if (_remark != nil || _remark.alias != nil) {
            if (![_remark.alias isEqualToString:@"备注名"]) {
                self.title = _remark.alias;
            }
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
}

- (void)getUserInfo:(NSString *)type withUid:(NSString *)uid
{
    [[HttpService sharedInstance] getUserInfo:@{@"uid":uid} completionBlock:^(id object) {
        
        UserInfo * user = (UserInfo *)object;
        if([type isEqualToString:@"1"])
        {
            [_dadButton sd_setBackgroundImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"baby_baba"]];
        }
        else if([type isEqualToString:@"2"])
        {
            [_monButton sd_setBackgroundImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"baby_mama"]];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = @"获取爸爸头像失败";
        if([type isEqualToString:@"1"])
        {
            msg = @"获取爸爸头像失败";
        }
        else if([type isEqualToString:@"2"])
        {
            msg = @"获取妈妈头像失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}



- (void)isFocus
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    if(user == nil)
    {
        return ;
    }
    
    [[HttpService sharedInstance] isFocus:@{@"baby_id":_babyInfo.baby_id,@"uid":user.uid} completionBlock:^(id object) {
        
        if(object == nil)
        {
            _babyInfo.is_focus = @"0";
            return ;
        }
        
        if([object intValue] == 1)
        {
            _babyInfo.is_focus = @"1";
            [specialCareBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        }
        else
        {
            _babyInfo.is_focus = @"0";
            [specialCareBtn setTitle:@"特别关注" forState:UIControlStateNormal];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
        NSString * msg = @"获取关系失败.";
        if(error != nil)
        {
            msg = @"加载失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
        
        _babyInfo.is_focus = @"0";
        [specialCareBtn setTitle:@"特别关注" forState:UIControlStateNormal];
    }];
}


- (void)HMSegmentedControlInitMethod
{
    segMentedControl = [[HMSegmentedControl alloc] init];
    [segMentedControl setSectionTitles:@[@"简介",@"动态",@"身高体重"]];
    segMentedControl.font = [UIFont systemFontOfSize:15];
    segMentedControl.textColor = [UIColor darkGrayColor];
    segMentedControl.selectedTextColor = [UIColor colorWithRed:104.0/225.0 green:193.0/255.0 blue:14.0/255.0 alpha:1.0];
    [segMentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [segMentedControl setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [segMentedControl setSelectionIndicatorHeight:1.0];
    [segMentedControl setSelectionIndicatorColor:[UIColor colorWithRed:104.0/255.0 green:193.0/255.0 blue:14.0/255.0 alpha:1.0]];
    segMentedControl.frame = CGRectMake(0, 0, _tabSelectionBar.bounds.size.width, _tabSelectionBar.bounds.size.height);
    segMentedControl.selectedSegmentIndex = 1;
    [_segScrollView setContentOffset:CGPointMake(segMentedControl.selectedSegmentIndex*320, 0)];
    [segMentedControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [_tabSelectionBar addSubview:segMentedControl];
}


#pragma mark 点击简介,动态,身高体重导航条监听方法
- (void)changePage:(HMSegmentedControl *)segBtn
{
    int curPage = segBtn.selectedSegmentIndex;
    [_segScrollView setContentOffset:CGPointMake(curPage*320, 0)];
}

//出生日期改变
- (void)dateChange:(id)sender
{
    NSString * dateStr = [[_datePicker date] formatDateString:@"yyyy-MM-dd"];
    SummaryCell * cell = (SummaryCell *)[_summaryTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell.summaryValueField.text = dateStr;
}


- (void)showList:(UIBarButtonItem *)Btn
{
    if (!isRemarksBtnShown)
    {
        [self.navigationController.view addSubview:remarksBtn];
        [self.navigationController.view addSubview:specialCareBtn];
        isRemarksBtnShown = YES;
    }
    else
    {
        [remarksBtn removeFromSuperview];
        [specialCareBtn removeFromSuperview];
        isRemarksBtnShown = NO;
    }
}

//更新备注
- (void)updateRemark
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
     //修改宝宝备注
     [[HttpService sharedInstance] updateBabyRemark:@{@"uid":user.uid,@"baby_id":_babyInfo.baby_id,@"alias":@"1", @"remark":@"3"} completionBlock:^(id object) {
         [SVProgressHUD showSuccessWithStatus:@"修改备注成功"];
     } failureBlock:^(NSError *error, NSString *responseString) {
         [SVProgressHUD showErrorWithStatus:responseString];
     }];
    
}

//删除宝宝备注
- (void)deleteRemark
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
     //删除宝宝备注
     [[HttpService sharedInstance] deleteBabyRemark:@{@"uid":user.uid,@"baby_id":_babyInfo.baby_id} completionBlock:^(id object) {

     } failureBlock:^(NSError *error, NSString *responseString) {
         NSString * msg = responseString;
         if (error)
         {
             msg = @"加载失败";
         }
         [SVProgressHUD showErrorWithStatus:msg];
     }];
}

//获取宝宝成长记录
- (void)getGrowRecords
{
    _growRecordArray = [NSArray array];
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
     //获取宝宝成长记录
     [[HttpService sharedInstance] getBabyGrowRecord:@{@"baby_id":_babyInfo.baby_id,@"offset":@"0",@"pagesize":@"10000",@"uid":user.uid} completionBlock:^(id object) {
         if ([object isKindOfClass:[NSArray class]]) {
             _growRecordArray = object;
             [_gridView reloadData];
         }
     } failureBlock:^(NSError *error, NSString *responseString) {
         NSString * msg = responseString;
         if (error) {
             msg = @"加载失败";
         }
         [SVProgressHUD showErrorWithStatus:msg];
     }];
    
}

- (void)refreshRecords
{
    _dyOffset = 0;
    [self getBabyRecords];
}

- (void)loadRecords
{
    _dyOffset = [_babyPersonalDyArray count];
    [self getBabyRecords];
}

//获取宝宝动态
- (void)getBabyRecords
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];

    //获取宝宝成长记录
    [[HttpService sharedInstance] getRecordByBaby:@{@"baby_id":_babyInfo.baby_id,@"offset":[NSString stringWithFormat:@"%i",_dyOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"uid":user.uid} completionBlock:^(id object) {
        
        [_dynamicListTableView headerEndRefreshing];
        [_dynamicListTableView footerEndRefreshing];
        if (_dyOffset == 0) {                                 //根据offset判断下拉还是上拉，如果上啦就清空数组
            [_babyPersonalDyArray removeAllObjects];
        }
        [_babyPersonalDyArray addObjectsFromArray:object];

        
        [_dynamicListTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [_dynamicListTableView headerEndRefreshing];
        [_dynamicListTableView footerEndRefreshing];

        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


#pragma mark - 表格，折线图切换
- (IBAction)changDisplayStyle:(UIButton *)sender {
//    if (sender.selected) {
//        [sender setSelected:NO];
//        [sender setBackgroundImage:[UIImage imageNamed:@"yuanquan.png"] forState:UIControlStateNormal];
//    }else{
//        [sender setSelected:YES];
//        [sender setBackgroundImage:[UIImage imageNamed:@"baby_baba"] forState:UIControlStateSelected];
//    }

    //折线图测试
    LineChartController *line = [[LineChartController alloc] init];
    [self.navigationController pushViewController:line animated:YES];
}

- (IBAction)fullScreen:(UIButton *)btn {
    
    [btn setSelected:!btn.selected];
    CGRect full = [UIScreen mainScreen].applicationFrame;
    if (btn.selected) {
        NSLog(@"全屏");
        [_heightAndWeightTableView removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            _heightAndWeightTableView.frame = full;
        }];
        _gridView.frame = CGRectMake(10, 45, 300,_heightAndWeightTableView.bounds.size.height - 105);
        [self.inStatusView addSubview:_heightAndWeightTableView];
    }else
    {
        NSLog(@"非全屏");
        [_heightAndWeightTableView removeFromSuperview];
        [UIView animateWithDuration:0.5 animations:^{
            _heightAndWeightTableView.frame = CGRectMake(320*2, 0, 320, _segScrollView.bounds.size.height);
        }];
        CGFloat height;
        if ([[UIScreen mainScreen] bounds].size.height < 500)
        {
            height = 170.f;
        }
        else
        {
            height = 250.f;
        }
        _gridView.frame = CGRectMake(10, 45, 300,height);
        [_segScrollView addSubview:_heightAndWeightTableView];
        
    }
}

- (IBAction)isYaoQing:(id)sender
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    //_yaoQingbgView.hidden = NO;
    if (sender == _monButton)
    {
        if(_babyInfo.mid != nil && [_babyInfo.mid length] != 0 && ![_babyInfo.mid isEqualToString:@"0"])
        {
            if([user.uid isEqualToString:_babyInfo.mid])
            {
                PersonCenterViewController * vc = [[PersonCenterViewController alloc] initWithNibName:nil bundle:nil];
                [self push:vc];
                vc = nil;
            }
            else
            {
                FriendHomeViewController * vc = [[FriendHomeViewController alloc] initWithNibName:nil bundle:nil];
                vc.friendId = _babyInfo.mid;
                [self push:vc];
                vc = nil;
            }
        }
        else
        {
            
            if(![user.uid isEqualToString:_babyInfo.fid])
            {
                return ;
            }
            [self.navigationController.view addSubview:_yaoQingbgView];
            _yaoQingbgView.hidden = NO;
        }
    }
    if (sender == _dadButton)
    {
        if(_babyInfo.fid != nil && [_babyInfo.fid length] != 0 && ![_babyInfo.fid isEqualToString:@"0"])
        {
            if([user.uid isEqualToString:_babyInfo.fid])
            {
                PersonCenterViewController * vc = [[PersonCenterViewController alloc] initWithNibName:nil bundle:nil];
                [self push:vc];
                vc = nil;
            }
            else
            {
                FriendHomeViewController * vc = [[FriendHomeViewController alloc] initWithNibName:nil bundle:nil];
                vc.friendId = _babyInfo.fid;
                [self push:vc];
                vc = nil;
            }
        }
        else
        {
            
            if(![user.uid isEqualToString:_babyInfo.mid])
            {
                return ;
            }
            
            [self.navigationController.view addSubview:_yaoQingbgView];
            _yaoQingbgView.hidden = NO;
        }
    }
    
}

//短信邀请界面
- (IBAction)msgYaoQingButton:(id)sender
{
    [_yaoQingbgView removeFromSuperview];
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    if (messageClass == nil)
    {
        return ;
    }
    
    // 发送短信
    if ([messageClass canSendText])
    {
        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
        picker.messageComposeDelegate = self;
        
        NSString *smsBody = [NSString stringWithFormat:Invitation_Msg_Content];
        picker.body=smsBody;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""message:@"该设备不支持短信功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)weiXinYaoQingButton:(id)sender
{
    [_yaoQingbgView removeFromSuperview];
    [[ShareManager sharePlatform] invitationWeXinFriend:@"亲爱的,我发现一个很不错的手机应用‘晒娃娃’,可以用来晒宝宝的 照片和视频。你也下一个一起玩吧。" withURL:@"http://www.shaiwawa.com/download"];
}

- (IBAction)hideCurView:(id)sender
{
    _yaoQingbgView.hidden = YES;
}

- (IBAction)dismissKeyboard:(id)sender
{
    [locateView removeFromSuperview];
    [self.view endEditing:YES];
    [self resignFirstResponder];
}

- (IBAction)hideInvitationView:(id)sender {
    [_yaoQingbgView removeFromSuperview];
}

- (void)showPraiseListVC
{
    PraiseViewController *praiseListVC = [[PraiseViewController alloc] init];
    [self.navigationController pushViewController:praiseListVC animated:YES];
}

- (void)showShareGrayView
{
    [self.view endEditing:YES];
    [self resignFirstResponder];
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


- (IBAction)hideGayShareFullV:(id)sender
{
    isShareViewShown = NO;
}

- (IBAction)showAddHAndWPageVC:(id)sender
{
    AddHeightAndWeightViewController *addHeightAndWeightVC =[[AddHeightAndWeightViewController alloc] initWithNibName:nil bundle:nil];
    addHeightAndWeightVC.babyInfo = _babyInfo;
    [self.navigationController pushViewController:addHeightAndWeightVC animated:YES];
}

- (void)showRemarkVC
{
    [self showList:nil];
    RemarksViewController *remarksVC = [[RemarksViewController alloc] initWithNibName:nil bundle:nil];
    remarksVC.babyInfo = _babyInfo;
    remarksVC.babyHomeVC = self;
    remarksVC.babyRemark = _remark;
    [self.navigationController pushViewController:remarksVC animated:YES];
}


- (void)specialCare
{
    [self showList:nil];
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    //判断当前宝宝的是否关注了
    if ([_babyInfo.is_focus intValue] == 1) {//1为表示已关注
        
        [[HttpService sharedInstance] unfollowBaby:@{@"uid":users.uid,@"baby_id":_babyInfo.baby_id} completionBlock:^(id object) {
            [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
            _babyInfo.is_focus = @"0";
            [specialCareBtn setTitle:@"特别关注" forState:UIControlStateNormal];
        } failureBlock:^(NSError *error, NSString *responseString) {
            NSString * msg = responseString;
            if (error) {
                msg = @"取消关注失败";
            }
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
    else                                     //2为表示未关注
    {
        
        [[HttpService sharedInstance] followBaby:@{@"uid":users.uid,@"baby_id":_babyInfo.baby_id} completionBlock:^(id object) {
            [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
            _babyInfo.is_focus = @"1";
            [specialCareBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        } failureBlock:^(NSError *error, NSString *responseString) {
            NSString * msg = responseString;
            if (error) {
                msg = @"关注失败";
            }
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
    
    
    
    
}





//更改宝宝信息
- (void)updateBabyInfo
{
    
    NSMutableDictionary * params = [@{} mutableCopy];
    params[@"baby_id"] = _babyInfo.baby_id;
    params[@"uid"] = _babyInfo.uid;
    params[@"mid"] = _babyInfo.mid;
    params[@"fid"] = _babyInfo.fid;
    params[@"baby_name"] = _babyInfo.baby_name;
    params[@"nickname"] = _babyInfo.nickname;
    params[@"avatar"] = _babyInfo.avatar;
    params[@"sex"] = _babyInfo.sex;
    params[@"city"] = _babyInfo.city;
    params[@"province"] = _babyInfo.province;
    params[@"country"] = @"中国";
    params[@"birth_height"] = _babyInfo.birth_height;
    params[@"birth_weight"] = _babyInfo.birth_weight;
    /*
    NSInteger timeInterval = [[NSDate dateFromString:_babyInfo.birthday withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
    NSString * timeIntervalStr = [NSString stringWithFormat:@"%d",timeInterval];
    */
    params[@"birthday"] = _babyInfo.birthday;
    
    //更新宝宝信息
    [[HttpService sharedInstance] updateBabyInfo:params completionBlock:^(id object) {
//        [_summaryTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString *msg = responseString;
        if (error)
        {
            msg = @"操作失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}



- (void)likeAction:(id)sender
{
    UserInfo * users = [[UserDefault sharedInstance] userInfo];
    UIButton * btn = (UIButton *)sender;
    BabyHomeDynamicCell * cell;
    if([btn.superview.superview.superview.superview isKindOfClass:[BabyHomeDynamicCell class]])
    {
        cell = (BabyHomeDynamicCell *)btn.superview.superview.superview.superview;
    }
    else if([btn.superview.superview.superview isKindOfClass:[BabyHomeDynamicCell class]])
    {
        cell = (BabyHomeDynamicCell *)btn.superview.superview.superview;
    }
    else
    {
        cell = (BabyHomeDynamicCell *)btn.superview.superview;
    }
    NSIndexPath * indexPath = [_dynamicListTableView indexPathForCell:cell];
    BabyRecord * record = _babyPersonalDyArray[indexPath.row];
    if([record.is_like isEqualToString:@"1"])
    {
        //取消赞
        [[HttpService sharedInstance] cancelLike:@{@"rid":record.rid,@"uid":users.uid} completionBlock:^(id object) {
            
            //[SVProgressHUD showSuccessWithStatus:@"取消赞成功."];
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
            [_dynamicListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
            
            //[SVProgressHUD showSuccessWithStatus:@"谢谢您的参与."];
            record.is_like = @"1";
            record.like_count = [NSString stringWithFormat:@"%i",[record.like_count intValue] + 1];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:[record.top_3_likes count] + 1];
            [tempArr addObjectsFromArray:record.top_3_likes];
            //生成一个字典
            NSMutableDictionary *zanDict = [@{} mutableCopy];
            zanDict[@"uid"] = users.uid;
            zanDict[@"avatar"] = users.avatar;
            zanDict[@"username"] = @"";
            zanDict[@"rid"] = @"";
            zanDict[@"add_time"] = @"";
            [tempArr insertObject:zanDict atIndex:0];
            record.top_3_likes = (NSArray *)tempArr;

            [_dynamicListTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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


- (void)keyboardShow:(NSNotification *)notification
{
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //NSLog(@"%@",[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey]);
    CGRect beginRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //NSLog(@"%f",self.view.frame.origin.y);
    
    [UIView animateWithDuration:duration animations:^{
        
        float offset ;
        if(beginRect.size.height == endRect.size.height)
        {
            offset = - beginRect.size.height + 65;
        }
        else
        {
            offset = beginRect.size.height - endRect.size.height;
        }
        self.view.frame = CGRectOffset(self.view.frame, 0,offset);
    }];
    
}

- (void)keyboardHide:(NSNotification *)notification
{
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0,  [OSHelper iOS7]?64:0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
    
}


- (void)showTopicDynamic:(UIButton *)sender
{
    
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    DDLogVerbose(@"%@",NSStringFromClass([scrollView class]));
    if(![scrollView isKindOfClass:[UITableView class]])
    {
        int curPage = scrollView.bounds.origin.x/320;
        [segMentedControl setSelectedSegmentIndex:curPage animated:YES];
    }
}

#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 11111)
    {
        if(![locateView.locate.city isEqualToString:_babyInfo.city])
        {
            _babyInfo.city = locateView.locate.city;
            _babyInfo.province = locateView.locate.state;
            [self updateBabyInfo];
        }
    }else if(actionSheet.tag == 999)
    {
        NSLog(@"%d",buttonIndex);
        //根据用户点击了那个按钮选择头像更换方式
        [self selectPhotoWithButtonIndex:buttonIndex];
    }
    else
    {
        NSLog(@"%i",buttonIndex);
        //选择了男生
        if(buttonIndex == 0)
        {
            //只有不相同的时候才更新
            if(![_babyInfo.sex isEqualToString:@"1"])
            {
                _babyInfo.sex = @"1";
                [self updateBabyInfo];
            }
        }
        //选择了女生
        else if(buttonIndex == 1)
        {
            //只有不相同的时候才更新
            if(![_babyInfo.sex isEqualToString:@"2"])
            {
                _babyInfo.sex = @"2";
                [self updateBabyInfo];
            }
        }
        
    }
}

#pragma mark - 根据用户选择照片上传方式
- (void)selectPhotoWithButtonIndex:(NSInteger)index
{
    // 判断是否支持相机
    //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    switch (index) {
        case 0:
            // 相机
            sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            // 相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
        case 2:
            // 取消
            return;
    }
    UIImagePickerController *imagePickerController =[[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

#pragma mark - UITableView Delegate and DataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _summaryTableView)
    {
        return [summaryKey count];
    }
    else if(tableView == _dynamicListTableView)
    {
        return [_babyPersonalDyArray count];
    }
    else
    {
        return _growRecordArray.count + 1;
    }
    
}
#pragma mark tableview代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    if (tableView == _summaryTableView)
    {
        static NSString *identify = @"Cell";
        SummaryCell *cell = (SummaryCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        cell.summaryKeyLabel.text = [summaryKey objectAtIndex:indexPath.row];
        cell.summaryValueField.delegate = self;
        cell.summaryValueField.tag = indexPath.row;
        cell.summaryValueField.enabled = NO;
        cell.sexImgView.hidden = YES;
        
        if ([_babyInfo.uid isEqualToString:users.uid] || [_babyInfo.uid isEqualToString:users.uid])
        {
            cell.summaryValueField.enabled = YES;
            
        }
        else
        {
             cell.summaryValueField.enabled = NO;
        }
        
        
        if (indexPath.row == 3)
        {
            cell.sexImgView.hidden = NO;
            cell.sexImgView.image = [UIImage imageNamed:[_babyInfo.sex intValue] == 1 ? @"main_boy.png" : @"main_girl.png"];
            cell.summaryValueField.text = nil;
            cell.summaryValueField.text = [_babyInfo.sex intValue] == 1 ? @"男" : @"女";
        }
       
        if (indexPath.row == 0)
        {
            cell.summaryValueField.text = nil;
            cell.summaryValueField.text = _babyInfo.nickname;
        }
        if (indexPath.row == 1)
        {
            cell.summaryValueField.text = nil;
            cell.summaryValueField.text = _babyInfo.baby_name;
        }
        if (indexPath.row == 2)
        {
            
            cell.summaryValueField.inputAccessoryView = _toolBar;
            cell.summaryValueField.inputView = _datePicker;
            //cell.summaryValueField.text = _babyInfo.birthday;
            cell.summaryValueField.text = [[NSDate dateWithTimeIntervalSince1970:[_babyInfo.birthday integerValue]] formatDateString:@"yyyy-MM-dd"];
        }
        if (indexPath.row == 4)
        {
            cell.summaryValueField.text = nil;
            cell.summaryValueField.text = _babyInfo.city;
        }
        if (indexPath.row == 5)
        {
            cell.summaryValueField.text = nil;
            cell.summaryValueField.keyboardType = UIKeyboardTypeNumberPad;
            cell.summaryValueField.inputAccessoryView = _toolBar;
            cell.summaryValueField.text = _babyInfo.birth_height;
        }
        if (indexPath.row == 6)
        {
            cell.summaryValueField.text = nil;
            cell.summaryValueField.keyboardType = UIKeyboardTypeNumberPad;
            cell.summaryValueField.inputAccessoryView = _toolBar;
            cell.summaryValueField.text = _babyInfo.birth_weight;
        }
        return cell;
    }

    else if(tableView == _dynamicListTableView)
    {
        BabyHomeDynamicCell * dynamicCell = [tableView dequeueReusableCellWithIdentifier:@"Celler"];
        BabyRecord * recrod = [_babyPersonalDyArray objectAtIndex:indexPath.row];
        dynamicCell.addressLabel.text = recrod.address;
        if(recrod.address == nil || [recrod.address length] == 0)
        {
            dynamicCell.locationImageView.hidden = YES;
        }
        else
        {
            dynamicCell.locationImageView.hidden = NO;
        }

        dynamicCell.dyContentTextView.attributedText = [NSStringUtil makeTopicString:recrod.content];
        [dynamicCell.babyAvatarImageView sd_setImageWithURL:[NSURL URLWithString:recrod.avatar] placeholderImage:Default_Avatar];
        dynamicCell.babyNameLabel.text = recrod.baby_nickname;
        NSString *usersex = nil;
        if ([users.sex intValue] == 0) {
            usersex = @"";
        }else if([users.sex intValue] == 1)
        {
            usersex = @"(爸爸)";
        }else
        {
            usersex = @"(妈妈)";
        }
        
        dynamicCell.whoLabel.text = [NSString stringWithFormat:@"%@%@",recrod.username,usersex];
        dynamicCell.releaseTimeLabel.text = [NSStringUtil calculateTime:recrod.add_time];
        [dynamicCell.zanButton setTitle:recrod.like_count forState:UIControlStateNormal];
        if([recrod.is_like isEqualToString:@"1"])
        {
            dynamicCell.zanButton.selected = YES;
        }
        else
        {
            dynamicCell.zanButton.selected = NO;
        }
        
        [dynamicCell.commentBtn setTitle:recrod.comment_count forState:UIControlStateNormal];
        [dynamicCell.zanButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
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
            [dynamicCell.praiseUserFirstBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal];
            if([recrod.top_3_likes count] > 1)
            {
                userDic = recrod.top_3_likes[1];
                [dynamicCell.praiseUserSecondBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal];
            }
            
            if([recrod.top_3_likes count] > 2)
            {
                userDic = recrod.top_3_likes[2];
                [dynamicCell.praiseUserThirdBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal];
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
            dynamicCell.scrollView.hidden = NO;
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
            dynamicCell.scrollView.hidden = NO;
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
                [dynamicCell.scrollView addSubview:imageView];
                imageView = nil;
            }
            [dynamicCell.scrollView setContentSize:CGSizeMake([recrod.images count] * width, CGRectGetHeight(dynamicCell.scrollView.bounds))];
            
        }
        else
        {
//            PublishImageView * imageView = [[PublishImageView alloc] initWithFrame:dynamicCell.scrollView.bounds withPath:nil];
//            [imageView setCloseHidden];
//            [dynamicCell.scrollView addSubview:imageView];
            dynamicCell.scrollView.hidden = YES;
//            imageView = nil;
        }
        
        [[dynamicCell.contentView viewWithTag:20000] removeFromSuperview];
        if(recrod.audio != nil && [recrod.audio length] > 0)
        {
            
            CGRect rect = CGRectMake(123, 123, 82, 50);
            if([recrod.images count] == 0 && (recrod.video == nil || [recrod.video length] == 0))
            {
                rect = CGRectMake(123, 20, 82, 50);
            }

            
            AudioView * audioView = [[AudioView alloc] initWithFrame:rect withPath:recrod.audio];
            audioView.tag = 20000;
            [audioView setCloseHidden];
            [dynamicCell.contentView addSubview:audioView];
        }


        return dynamicCell;
    }
    else
    {
        NetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
        if (indexPath.row == 0) {
            cell.recordDay.text = @"日期";
            cell.height.text = @"身高(cm)";
            cell.weight.text = @"体重(kg)";
            cell.bodyType.text = @"体型";
        }else{
            BabyGrowRecord *b = _growRecordArray[indexPath.row - 1];
            cell.babyGrowRecord = b;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _dynamicListTableView)
    {
        DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] initWithNibName:nil bundle:nil];
        BabyRecord * record = [_babyPersonalDyArray objectAtIndex:indexPath.row];
        dynamicDetailVC.babyRecord = record;
        [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    }
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell *cell = nil;
    if (tableView == _gridView) {
        cell =(NetCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height - 2;
    }else if(tableView == _dynamicListTableView)
    {
        BabyRecord *record = _babyPersonalDyArray[indexPath.row];
        if ((record.video && record.video.length) || record.images.count) {
            return 293.0f;
        }else
        {
            return 293.0f - 143.0f;
        }
    }else
    {
        cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    //选择性别
    if(textField.tag == 3)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        [actionSheet showInView:self.view];
        return NO;
    }
    
    //选择城市
    if(textField.tag == 4)
    {
        locateView = [[TSLocateView alloc] initWithTitle:@"定位城市" delegate:self];
        locateView.tag = 11111;
        [locateView showInView:self.view];
        return NO;
    }
    
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSString * text = [InputHelper trim:textField.text];
    if(textField.tag == 0)
    {
        if([InputHelper isEmpty:text])
        {
            [SVProgressHUD showErrorWithStatus:@"宝宝昵称不能为空."];
        }
        else if(![_babyInfo.nickname isEqualToString:text])
        {
            //不和原来的昵称相同，才提交服务端.
            _babyInfo.nickname = text;
            [self updateBabyInfo];
        }
    }
    
    if(textField.tag == 1)
    {
        if(![_babyInfo.baby_name isEqualToString:text])
        {
            //不和原来的名称相同，才提交服务端
            _babyInfo.baby_name = text;
            [self updateBabyInfo];
        }
    }
    

    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString * text = [InputHelper trim:textField.text];
    NSInteger timeInterval = [[NSDate dateFromString:text withFormat:@"yyyy-MM-dd"] timeIntervalSince1970];
    text = [NSString stringWithFormat:@"%d",timeInterval];
    if(textField.tag == 2)
    {
        if(![_babyInfo.birthday isEqualToString:text])
        {
            //不和原来的出生日期相同，才提交服务端
            _babyInfo.birthday = text;
            [self updateBabyInfo];
        }
    }
    
    if(textField.tag == 5)
    {
        if(![_babyInfo.birth_height isEqualToString:text])
        {
            //不和原来的身高相同，才提交服务端
            _babyInfo.birth_height = text;
            [self updateBabyInfo];
        }
    }
    
    if(textField.tag == 6)
    {
        if(![_babyInfo.birth_weight isEqualToString:text])
        {
            //不和原来的体重相同，才提交服务端
            _babyInfo.birth_weight = text;
            [self updateBabyInfo];
        }
    }
}

#pragma mark - MFMessageComposeViewControllerDelegate Methods

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    [self hideCurView:nil];
    if (result == MessageComposeResultCancelled)
    {
        NSLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent)
    {
        NSLog(@"Message sent");
    }
    else
    {
        NSLog(@"Message failed");
    }
}

#pragma mark - 点击宝宝头像更改头像
- (IBAction)changeAvator:(UIButton *)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    actionSheet.tag = 999;
    [actionSheet showFromRect:CGRectMake(0, 0, 320, 100) inView:self.view animated:YES];
}

#pragma mark - 照片选择器代理方法
//点击相册中的图片 货照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    _image = image;
    NSString * fileName = [[IO generateRndString] stringByAppendingPathExtension:@"png"];
    NSString *filePath = [IO pathForResource:fileName inDirectory:Avatar_Folder];
    _filePath = filePath;
    //保存到本地
    if(![IO writeFileToPath:filePath withData:UIImageJPEGRepresentation(image, 0.5)])
    {
        [SVProgressHUD showErrorWithStatus:@"保存失败."];
        return ;
    }
    [self uploadPhotoWithImage:image filePath:filePath];
}

#pragma mark - 上传图片到服务器
- (void)uploadPhotoWithImage:(UIImage *)image filePath:(NSString *)filePath
{
    //先把头像传到七牛
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    //上传图片到服务器
    [[QNUploadHelper sharedHelper] uploadFileData:UIImageJPEGRepresentation(image, 0.5f) withKey:[filePath lastPathComponent]];
    //上传失败调用方法
    [[QNUploadHelper sharedHelper] setUploadFailure:^(NSString * path){
        
        [SVProgressHUD dismiss];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"图片上传失败" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"重试", nil];
        [alertView show];
        alertView = nil;
    }];
    //上传成功调用方法
    [[QNUploadHelper sharedHelper] setUploadSuccess:^(NSString * path){
        _babyInfo.avatar = [NSString stringWithFormat:@"%@%@",QN_URL,[path lastPathComponent]];;
        [self updateBabyInfo];  //更新服务器宝宝信息
        [_babyAvatarImgView setImage:[image ellipseImageWithDefaultSetting] forState:UIControlStateNormal]; //设置头像
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];//删除本地缓存
    }];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - alertView提示用户是否重新上传图片
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        return ;
    }
    [self uploadPhotoWithImage:_image filePath:_filePath];
}

/*
#pragma mark -  UIScrollViewDelegate Methods
int _lastPosition;    //A variable define in headfile

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPostion = scrollView.contentOffset.y;
    NSLog(@"%d",currentPostion);
    
    
}
*/

@end
