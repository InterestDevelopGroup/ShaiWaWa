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
#import "ReleaseDynamic.h"
#import "TopicListOfDynamic.h"
#import "UserDefault.h"
#import "ShareView.h"


#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
@interface ChooseModeViewController ()
{
    ShareView *sv;
    AppDelegate *mydelegate;
    SearchDynamicViewController *searchDyVC;
}
@property (nonatomic,strong) MJRefreshHeaderView * refreshHeaderView;
@end

@implementation ChooseModeViewController
@synthesize dyArray;
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
    dyArray = [[NSMutableArray alloc] init];
    if (![dyArray isEqual:[NSNull null]]) {
        [_dynamicPageTableView addHeaderWithTarget:self action:@selector(refreshData:)];
        [_dynamicPageTableView setHeaderRefreshingText:@"数据正在加载"];
        [_dynamicPageTableView headerBeginRefreshing];
        
        [_dynamicPageTableView addFooterWithTarget:self action:@selector(loadMoreData)];
        [_dynamicPageTableView setFooterPullToRefreshText:@"上拉加载更多"];
        [_dynamicPageTableView setFooterRefreshingText:@"数据正在加载"];
    }
    
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    __block __weak ChooseModeViewController *lchoose = self;
    searchDyVC = [[SearchDynamicViewController alloc] init];
    [searchDyVC setSearchBlock:^(NSMutableArray *array){
        
        
        if ([array count]>0) {
            lchoose.dyArray = array;
        }
        else
        {
            lchoose.dyArray = nil;
        }
        [lchoose.dynamicPageTableView reloadData];
    }];
    [self initUI];
    
    [self setSpecialBlock:^(NSMutableArray *arr)
     {
         if (!arr) {
             lchoose.dyArray = [arr copy];
             [lchoose.dynamicPageTableView reloadData];
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)initUI
{
    users = [[UserDefault sharedInstance] userInfo];
    mydelegate = [[UIApplication sharedApplication] delegate];
    NSLog(@"%@",users.avatar);
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

    
    isMenuShown = NO;
    MainMenu *mainMenu = [[MainMenu alloc] initWithFrame:CGRectMake(0, 0, 240, 390)];
    mainMenu.userInteractionEnabled = YES;
    //[mainMenu.btn addTarget:self action:@selector(printString) forControlEvents:UIControlEventTouchUpInside];
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
//        [viewer addGestureRecognizer:_userViewTap];
        
        [self userViewTouchEvent:viewer];
        
    }];
   
    
    mainMenu.nameLabel.text = users.username;
    if (users.avatar.length > 0) {
        mainMenu.touXiangImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL fileURLWithPath:users.avatar]]];
//        [UIImage imageWithContentsOfFile:users.avatar];
        //[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:users.avatar]]];
        
    }
    else
    {
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Avatar"] stringByAppendingPathComponent:@"avatar_DefaultPic.png"];
        UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
        mainMenu.touXiangImgView.image = savedImage;
    }
    
    
    //[mainMenu.user addGestureRecognizer:_userViewTap];
    [_mainAddView addSubview:mainMenu];
    
    isDropMenuShown = NO;
    MainDropMenu *dropMenu =[[MainDropMenu alloc] initWithFrame:CGRectMake(0, 0, _grayDropView.bounds.size.width, 80)];
    
    [dropMenu.allButton  addTarget:self action:@selector(showAllDyList) forControlEvents:UIControlEventTouchUpInside];
    
    [dropMenu.onlyMineButton addTarget:self action:@selector(showOnlyMyBabyDyList) forControlEvents:UIControlEventTouchUpInside];
    
    [dropMenu.specialCareButton addTarget:self action:@selector(showSpecialCareDyList) forControlEvents:UIControlEventTouchUpInside];
    
    [dropMenu.searchDyButton addTarget:self action:@selector(showSearchDyVC) forControlEvents:UIControlEventTouchUpInside];
    [_grayDropView addSubview:dropMenu];
    
    isShareViewShown = NO;
    
    [_dynamicPageTableView clearSeperateLine];
    [_dynamicPageTableView registerNibWithName:@"DynamicCell" reuseIdentifier:@"Cell"];
    
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
    __block __weak ChooseModeViewController *lchoose = self;
    sv = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
    
    //sv.deleteButton.hidden = YES;
    
    [sv setDeleteBlock:^(){
        [lchoose deleteDyEvent];
    }];
    [sv setCollectionBlock:^(){
        [lchoose colloctionDyEvent];
    }];
    [_shareView addSubview:sv];
    
    
    
    
    //[_dynamicPageTableView footerBeginRefreshing];
    
    
//    UIRefreshControl *tb_refresh=[[UIRefreshControl alloc] init];
//    [tb_refresh addTarget:self action:@selector(refreshData:) forControlEvents:UIControlEventValueChanged];
//    [tb_refresh setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉刷新"] ];
//    [_dynamicPageTableView addSubview:tb_refresh];
//    _dynamicPageTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _dynamicPageTableView.bounds.size.width, 0.01)];
//    
//    [self refreshData:nil];
  
    /*
    //获取好友宝宝动态请求失败
    [[HttpService sharedInstance] getRecordByFriend:@{@"friend_id":@"8",@"offset":@"0",  @"pagesize":@"10"} completionBlock:^(id object) {
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
     */
    [self isNoBabyAndFriend];

    
}

- (void)refreshData:(UIRefreshControl *)refreshControl
{
    [refreshControl endRefreshing];
    dyArray = nil;
    //获取宝宝所有动态 
    [[HttpService sharedInstance] getRecordList:@{@"offset":@"0", @"pagesize":@"10",@"uid":users.uid} completionBlock:^(id object) {
        dyArray = [object objectForKey:@"result"];
        [_dynamicPageTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
   
}
- (void)loadMoreData
{
    [[HttpService sharedInstance] getRecordList:@{@"offset":[NSString stringWithFormat:@"%d",[dyArray count]], @"pagesize":@"10",@"uid":users.uid} completionBlock:^(id object) {
        
        if (![[object objectForKey:@"result"] isEqual:[NSNull null]]) {
            if ( [[object objectForKey:@"result"] count] == 0) {
                [SVProgressHUD showErrorWithStatus:@"暂时未有新动态"];
            }
            else
            {
                [dyArray addObjectsFromArray:[object objectForKey:@"result"]];
                [_dynamicPageTableView reloadData];
            }
        }
    

         [_dynamicPageTableView footerEndRefreshing];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![dyArray isEqual:[NSNull null]]) {
      
         return [dyArray count];
    }
    else
    {
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
//    dynamicCell.babyNameLabel.text = [[dyArray objectAtIndex:indexPath.row] objectForKey:@""];
  
    if (![[[dyArray objectAtIndex:indexPath.row] objectForKey:@"add_time"] isEqual:[NSNull null]]) {
        if (dyArray != nil) {
            dynamicCell.releaseTimeLabel.text = [[dyArray objectAtIndex:indexPath.row] objectForKey:@"add_time"];
        }
        
    }
    if (![[[dyArray objectAtIndex:indexPath.row] objectForKey:@"address"] isEqual:[NSNull null]]) {
        if (dyArray != nil) {
        dynamicCell.addressLabel.text = [[dyArray objectAtIndex:indexPath.row] objectForKey:@"address"];
        }
    }
    else
    {
         dynamicCell.addressLabel.text = @"中国";
    }
    if (![[[dyArray objectAtIndex:indexPath.row] objectForKey:@"content"] isEqual:[NSNull null]]) {
        if (dyArray != nil) {
         dynamicCell.dyContentTextView.text = [[dyArray objectAtIndex:indexPath.row] objectForKey:@"content"];
        }
    }
    
    
    if (![[[dyArray objectAtIndex:indexPath.row] objectForKey:@"baby_id"] isEqual:[NSNull null]]) {
        if (dyArray != nil) {
            
            [[HttpService sharedInstance] getBabyInfo:@{@"baby_id":[[dyArray objectAtIndex:indexPath.row] objectForKey:@"baby_id"]} completionBlock:^(id object) {
                
                
                 if (![[[object objectForKey:@"result"] objectAtIndex:0] isEqual:[NSNull null]]) {
                
//                     dynamicCell.imageView.image = [UIImage imageWithContentsOfFile:[[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]];
                     dynamicCell.babyNameLabel.text = [[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"baby_name"];
                      dynamicCell.babyBirthdayLabel.text = [[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"birthday"];
                 }
                //summaryValue = [object objectForKey:@"result"];
                //[_summaryTableView reloadData];
            } failureBlock:^(NSError *error, NSString *responseString) {
                [SVProgressHUD showErrorWithStatus:responseString];
            }];
        }
    }
    
    //赞用户，取消赞用户模块
    [[HttpService sharedInstance] getLikingList:@{@"rid":[[dyArray objectAtIndex:indexPath.row] objectForKey:@"rid"]} completionBlock:^(id object) {
        if (![[object objectForKey:@"result"] isEqual:[NSNull null]]) {
              [dynamicCell.zanButton setTitle:[NSString stringWithFormat:@"%d",[[object objectForKey:@"result"] count]] forState:UIControlStateNormal];
            
            [[HttpService sharedInstance] getUserInfo:@{@"uid":[[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"uid"]} completionBlock:^(id obj) {
                //NSLog(@"%@ %@",[[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"],users.avatar);
                [dynamicCell.praiseUserFirstBtn setImage:[UIImage imageWithContentsOfFile:users.avatar] forState:UIControlStateNormal];
                dynamicCell.praiseUserFirstBtn.hidden = NO;
                //                 [dynamicCell.praiseUserFirstBtn setImage:[UIImage imageWithContentsOfFile:users.avatar] forState:UIControlStateNormal];
            } failureBlock:^(NSError *error, NSString *responseString) {
                NSString * msg = responseString;
                if (error) {
                    msg = @"加载失败";
                }
                [SVProgressHUD showErrorWithStatus:msg];
            }];
            if ([[object objectForKey:@"result"] count]>1) {
                [[HttpService sharedInstance] getUserInfo:@{@"uid":[[[object objectForKey:@"result"] objectAtIndex:1] objectForKey:@"uid"]} completionBlock:^(id obj) {
//                    [dynamicCell.praiseUserSecondBtn setImage:[UIImage imageWithContentsOfFile:[[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]] forState:UIControlStateNormal];
                    [dynamicCell.praiseUserSecondBtn setImage:[UIImage imageWithContentsOfFile:users.avatar] forState:UIControlStateNormal];
                    dynamicCell.praiseUserSecondBtn.hidden = NO;
                } failureBlock:^(NSError *error, NSString *responseString) {
                    NSString * msg = responseString;
                    if (error) {
                        msg = @"加载失败";
                    }
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            }
            if ([[object objectForKey:@"result"] count]>2) {
                [[HttpService sharedInstance] getUserInfo:@{@"uid":[[[object objectForKey:@"result"] objectAtIndex:2] objectForKey:@"uid"]} completionBlock:^(id obj) {
//                    [dynamicCell.praiseUserThirdBtn setImage:[UIImage imageWithContentsOfFile:[[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]] forState:UIControlStateNormal];
                    [dynamicCell.praiseUserThirdBtn setImage:[UIImage imageWithContentsOfFile:users.avatar] forState:UIControlStateNormal];
                     dynamicCell.praiseUserThirdBtn.hidden = NO;
                } failureBlock:^(NSError *error, NSString *responseString) {
                    NSString * msg = responseString;
                    if (error) {
                        msg = @"加载失败";
                    }
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
                
            }
            
            
           
        }
        else
        {
            [dynamicCell.zanButton setTitle:[NSString stringWithFormat:@"0"] forState:UIControlStateNormal];
            dynamicCell.praiseUserFirstBtn.hidden = YES;
            dynamicCell.praiseUserSecondBtn.hidden = YES;
            dynamicCell.praiseUserThirdBtn.hidden = YES;
        }
        
      
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
    
    dynamicCell.moreBtn.tag = indexPath.row + 2222;
    dynamicCell.zanButton.tag = indexPath.row + 555;
    [dynamicCell.zanButton addTarget:self action:@selector(praiseDYEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    [dynamicCell.praiseUserFirstBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
    dynamicCell.praiseUserFirstBtn.tag = [[[dyArray objectAtIndex:indexPath.row] objectForKey:@"rid"] intValue];
    [dynamicCell.praiseUserSecondBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
     dynamicCell.praiseUserSecondBtn.tag = [[[dyArray objectAtIndex:indexPath.row] objectForKey:@"rid"] intValue];
    [dynamicCell.praiseUserThirdBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
     dynamicCell.praiseUserThirdBtn.tag = [[[dyArray objectAtIndex:indexPath.row] objectForKey:@"rid"] intValue];
    [dynamicCell.moreBtn addTarget:self action:@selector(showShareGrayView:) forControlEvents:UIControlEventTouchUpInside];
    
    [dynamicCell.topicBtn addTarget:self action:@selector(showTopicOfDyVC) forControlEvents:UIControlEventTouchUpInside];

    
    return dynamicCell;
    
}

- (void)colloctionDyEvent
{
     [self hideGayShareV:nil];
    [[HttpService sharedInstance] addFavorite:@{@"rid":[[dyArray objectAtIndex:([mydelegate.deleteDyId intValue]-2222)] objectForKey:@"rid"],@"uid":users.uid} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
- (void)deleteDyEvent
{
//    __block __weak ChooseModeViewController *lchoose = self;
    [self hideGayShareV:nil];
    [[HttpService sharedInstance] deleteRecord:@{@"rid":[[dyArray objectAtIndex:([mydelegate.deleteDyId intValue]-2222)] objectForKey:@"rid"],@"uid":users.uid} completionBlock:^(id object) {
        [[HttpService sharedInstance] getRecordList:@{@"offset":@"0", @"pagesize":@"10",@"uid":users.uid} completionBlock:^(id object) {
            dyArray = [object objectForKey:@"result"];
            [_dynamicPageTableView reloadData];
            [SVProgressHUD showSuccessWithStatus:@"加载完成"];
        } failureBlock:^(NSError *error, NSString *responseString) {
            [SVProgressHUD showErrorWithStatus:responseString];
        }];
         [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
}

- (void)praiseDYEvent:(UIButton *)button
{

    __block NSArray *praiseUserList;
    NSLog(@"获取赞用户列表:%@",@{@"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"]});
    [[HttpService sharedInstance] getLikingList:@{@"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"]} completionBlock:^(id object) {
        praiseUserList = [[NSArray alloc] init];
    if (![[object objectForKey:@"result"] isEqual:[NSNull null]]) {
        [button setTitle:[NSString stringWithFormat:@"%d",[[object objectForKey:@"result"] count]] forState:UIControlStateNormal];
        for (int i = 0; i < [[object objectForKey:@"result"] count]; i++) {
            NSString *priaseUid = [[[object objectForKey:@"result"] objectAtIndex:i] objectForKey:@"uid"];
            praiseUserList = [praiseUserList arrayByAddingObject:priaseUid];
        }
        
        
        if (![praiseUserList containsObject:users.uid]) {
            NSLog(@"添加赞:%@",@{@"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"],@"uid":users.uid});
            
            [[HttpService sharedInstance] addLike:@{@"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"],@"uid":users.uid} completionBlock:^(id object) {
                
                [[HttpService sharedInstance] getLikingList:@{@"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"]} completionBlock:^(id obj) {
                    
                    [_dynamicPageTableView reloadData];
                } failureBlock:^(NSError *error, NSString *responseString) {
                    NSString * msg = responseString;
                    if (error) {
                        msg = @"加载失败";
                    }
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            } failureBlock:^(NSError *error, NSString *responseString) {
                NSString * msg = responseString;
                if (error) {
                    msg = @"加载失败";
                }
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }else{
            NSLog(@"取消赞:%@",@{@"like_id":[[[object objectForKey:@"result"] objectAtIndex:[praiseUserList indexOfObject:users.uid]] objectForKey:@"like_id"],
                              @"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"],@"uid":users.uid});
            [[HttpService sharedInstance] cancelLike:@{@"like_id":[[[object objectForKey:@"result"] objectAtIndex:[praiseUserList indexOfObject:users.uid]] objectForKey:@"like_id"],
                                                       @"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"],@"uid":users.uid} completionBlock:^(id object) {
                                                           [[HttpService sharedInstance] getLikingList:@{@"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"]} completionBlock:^(id obj) {
                                                               [_dynamicPageTableView reloadData];
                                                           } failureBlock:^(NSError *error, NSString *responseString) {
                                                               NSString * msg = responseString;
                                                               if (error) {
                                                                   msg = @"加载失败";
                                                               }
                                                               [SVProgressHUD showErrorWithStatus:msg];
                                                           }];
            } failureBlock:^(NSError *error, NSString *responseString) {
                NSString * msg = responseString;
                if (error) {
                    msg = @"加载失败";
                }
                [SVProgressHUD showErrorWithStatus:msg];
            }];
            }
        }
        else
        {
             NSLog(@"第一次添加赞:%@",@{@"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"],@"uid":users.uid});
            [[HttpService sharedInstance] addLike:@{@"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"],@"uid":users.uid} completionBlock:^(id obje) {
                
                [[HttpService sharedInstance] getLikingList:@{@"rid":[[dyArray objectAtIndex:(button.tag-555)] objectForKey:@"rid"]} completionBlock:^(id obj) {
                DynamicCell *dycell  = (DynamicCell *)[_dynamicPageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(button.tag-555) inSection:0]];
                
                [[HttpService sharedInstance] getUserInfo:@{@"uid":[[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"uid"]} completionBlock:^(id objsub) {
                    //                    [dynamicCell.praiseUserFirstBtn setImage:[UIImage imageWithContentsOfFile:[[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]] forState:UIControlStateNormal];
                    [dycell.praiseUserFirstBtn setImage:[UIImage imageWithContentsOfFile:users.avatar] forState:UIControlStateNormal];
                } failureBlock:^(NSError *error, NSString *responseString) {
                    NSString * msg = responseString;
                    if (error) {
                        msg = @"加载失败";
                    }
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
                
                if ([[obj objectForKey:@"result"] count]>1) {
                    [[HttpService sharedInstance] getUserInfo:@{@"uid":[[[obj objectForKey:@"result"] objectAtIndex:1] objectForKey:@"uid"]} completionBlock:^(id objsub) {
                        //                    [dynamicCell.praiseUserSecondBtn setImage:[UIImage imageWithContentsOfFile:[[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]] forState:UIControlStateNormal];
                        [dycell.praiseUserSecondBtn setImage:[UIImage imageWithContentsOfFile:users.avatar] forState:UIControlStateNormal];
                    } failureBlock:^(NSError *error, NSString *responseString) {
                        NSString * msg = responseString;
                        if (error) {
                            msg = @"加载失败";
                        }
                        [SVProgressHUD showErrorWithStatus:msg];
                    }];
                }
                if ([[obj objectForKey:@"result"] count]>2) {
                    [[HttpService sharedInstance] getUserInfo:@{@"uid":[[[obj objectForKey:@"result"] objectAtIndex:2] objectForKey:@"uid"]} completionBlock:^(id objsub) {
                        //                    [dynamicCell.praiseUserThirdBtn setImage:[UIImage imageWithContentsOfFile:[[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]] forState:UIControlStateNormal];
                        [dycell.praiseUserThirdBtn setImage:[UIImage imageWithContentsOfFile:users.avatar] forState:UIControlStateNormal];

                    } failureBlock:^(NSError *error, NSString *responseString) {
                        NSString * msg = responseString;
                        if (error) {
                            msg = @"加载失败";
                        }
                        [SVProgressHUD showErrorWithStatus:msg];
                    }];
                    
                }
                    [_dynamicPageTableView reloadData];
                } failureBlock:^(NSError *error, NSString *responseString) {
                    NSString * msg = responseString;
                    if (error) {
                        msg = @"加载失败";
                    }
                    [SVProgressHUD showErrorWithStatus:msg];
                }];
            } failureBlock:^(NSError *error, NSString *responseString) {
                NSString * msg = responseString;
                if (error) {
                    msg = @"加载失败";
                }
                [SVProgressHUD showErrorWithStatus:msg];
            }];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] init];
    dynamicDetailVC.r_id = [[dyArray objectAtIndex:indexPath.row] objectForKey:@"rid"];
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
     [[UserDefault sharedInstance] setUserInfo:nil];
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
- (void)showAllDyList
{
     [self hideGrayDropView:nil];
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getRecordList:@{@"offset":@"0", @"pagesize":@"10",@"uid":user.uid} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
- (void)showOnlyMyBabyDyList
{
    [self hideGrayDropView:nil];
    [[HttpService sharedInstance] getRecordList:@{@"offset":@"0", @"pagesize":@"10",@"uid":users.uid} completionBlock:^(id object) {
        dyArray = [object objectForKey:@"result"];
        [_dynamicPageTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
}
- (void)showSpecialCareDyList
{
     [self hideGrayDropView:nil];
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getRecordByFollow:@{@"uid":user.uid,@"offset":@"0", @"pagesize":@"10"} completionBlock:^(id object) {
        dyArray = [object objectForKey:@"result"];
        [_dynamicPageTableView reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
}
- (void)showSearchDyVC
{
    [self hideGrayDropView:nil];
    
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

- (void)showPraiseListVC:(UIButton *)sender
{
    PraiseViewController *praiseListVC = [[PraiseViewController alloc] init];
    praiseListVC.priaseRid = [NSString stringWithFormat:@"%d",sender.tag];
    [self.navigationController pushViewController:praiseListVC animated:YES];
}

- (void)showShareGrayView:(UIButton *)button
{
    mydelegate.deleteDyId = [NSString stringWithFormat:@"%d",button.tag];
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
    ReleaseDynamic *releaseVC;
    if ([UIScreen mainScreen].bounds.size.height < 490.0) {
         releaseVC = [[ReleaseDynamic alloc] initWithNibName:@"ReleaseDynamic" bundle:[NSBundle mainBundle]];
    }
    else
    {
         releaseVC = [[ReleaseDynamic alloc] initWithNibName:@"ReleaseDynamic" bundle:[NSBundle mainBundle]];
    }
         [self.navigationController pushViewController:releaseVC animated:YES];
    
}
- (void)showTopicOfDyVC
{
    TopicListOfDynamic *topicListOfDyVC = [[TopicListOfDynamic alloc] init];
    [self.navigationController pushViewController:topicListOfDyVC animated:YES];
}

- (void)isNoBabyAndFriend
{
    [[HttpService sharedInstance] getBabyList:@{@"offset":@"0",
                                                @"pagesize":@"10",
                                                @"uid":users.uid}
                              completionBlock:^(id object) {
                                  
                                  [[HttpService sharedInstance] getFriendList:@{@"uid":users.uid,@"offset":@"0", @"pagesize": @"10"} completionBlock:^(id obj) {
        
                                      if (([[object objectForKey:@"result"] isEqual:[NSNull null]] || [[object objectForKey:@"result"] count] == 0) && ([[obj objectForKey:@"result"] isEqual:[NSNull null]] || [[obj objectForKey:@"result"] count] == 0)) {
                                          _btnAdd.hidden = NO;
                                          _btnSearch.hidden = NO;
                                          _btnView.hidden = NO;
                                          _releaseBtn.hidden = YES;
                                      }
        
                                  } failureBlock:^(NSError *error, NSString *responseString) {
                                      NSString * msg = responseString;
                                      if (error) {
                                          msg = @"加载失败";
                                      }
                                      [SVProgressHUD showErrorWithStatus:msg];
                                  }];

                              } failureBlock:^(NSError *error, NSString *responseString) {
                                  NSString * msg = responseString;
                                  if (error) {
                                      msg = @"加载失败";
                                  }
                                  [SVProgressHUD showErrorWithStatus:msg];
                              }];
    
}

- (void)publicErrorMsg
{
    /*
     NSString * msg = responseString;
     if (error) {
     msg = @"加载失败";
     }
     [SVProgressHUD showErrorWithStatus:msg];
     */
}

@end
