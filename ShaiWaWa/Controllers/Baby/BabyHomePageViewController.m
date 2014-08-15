//
//  BabyHomePageViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BabyHomePageViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "SummaryCell.h"
#import "BabyPersonalCell.h"
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
@interface BabyHomePageViewController ()
@property (nonatomic, strong) BabyInfo *babyInfo;
@property (nonatomic, strong) NSMutableArray *babyPersonalDyArray;
@property (nonatomic, strong) NSString *dyNum;
@end

@implementation BabyHomePageViewController
@synthesize curBaby_id;
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (!isFullList) {
        [self HMSegmentedControlInitMethod];
        isFullList = NO;
    }
    else
    {
        [self HMSegmentedControlInitMethodFull];
        isFullList = YES;
    }
}

#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"小龙";
    [self setLeftCusBarItem:@"square_back" action:nil];
    _babyInfo = [[BabyInfo alloc] init];
    _babyPersonalDyArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *right_doWith= nil;
    if ([OSHelper iOS7])
    {
        right_doWith = [self customBarItem:@"user_gengduo" action:@selector(showList:) size:CGSizeMake(38, 30) imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
        
    }
    else
    {
        right_doWith = [self customBarItem:@"user_gengduo" action:@selector(showList:)];
    }
    self.navigationItem.rightBarButtonItem = right_doWith;
    remarksBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [remarksBtn setBackgroundColor:[UIColor whiteColor]];
    [remarksBtn setTitle:@"备注信息" forState:UIControlStateNormal];
    [remarksBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    remarksBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    remarksBtn.frame = CGRectMake(self.navigationController.navigationBar.bounds.size.width-90, self.navigationController.navigationBar.bounds.size.height+10, 84, 41);
    [remarksBtn addTarget:self action:@selector(showRemarkVC) forControlEvents:UIControlEventTouchUpInside];
    
    specialCareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [specialCareBtn setBackgroundColor:[UIColor whiteColor]];
    [specialCareBtn setTitle:@"特别关注" forState:UIControlStateNormal];
    [specialCareBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    specialCareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    specialCareBtn.frame = CGRectMake(self.navigationController.navigationBar.bounds.size.width-90, self.navigationController.navigationBar.bounds.size.height+51, 84, 41);
    [specialCareBtn addTarget:self action:@selector(specialCare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yaoQingbgView];
    isRemarksBtnShown = NO;
    isRightBtnSelected = NO;
    isShareViewShown = NO;
    isFullList = NO;
    self.view = _inStatusView;
    [self HMSegmentedControlInitMethod];
    [self HMSegmentedControlInitMethodFull];
   
    babyDyList = [[NSMutableArray alloc] init];
    summaryKey = [NSArray arrayWithObjects:@"昵称",@"姓名",@"出生日期",@"性别",@"所在城市",@"出生身高",@"出生体重", nil];
    summaryDic = [[NSMutableDictionary alloc] init];
   UserInfo *users = [[UserDefault sharedInstance] userInfo];
    
    NSLog(@"%@",@{@"baby_id":curBaby_id,@"offset":@"0",@"pagesize":@"10",@"uid":users.uid});
    //根据用户ID以及宝宝id获取相应动态
    [[HttpService sharedInstance] getRecordByUserID:@{@"baby_id":curBaby_id,@"offset":@"0",@"pagesize":@"10",@"uid":users.uid} completionBlock:^(id object) {
         NSLog(@"唉");
        if (![[object objectForKey:@"result"] isEqual:[NSNull null]]) {
            _babyPersonalDyArray = [object objectForKey:@"result"];
            _dyNum =[NSString stringWithFormat:@"动态(%i)",[[object objectForKey:@"result"] count]];
             [segMentedControl setSectionTitles:@[@"简介",_dyNum,@"身高体重"]];
            [_dynamicListTableView reloadData];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    /*
    //删除宝宝备注
    [[HttpService sharedInstance] deleteBabyRemark:@{@"uid":@"2",@"baby_id":@"2"} completionBlock:^(id object) {
         [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    */
    /*
    //获取宝宝备注
    [[HttpService sharedInstance] getBabyRemark:@{@"uid":@"2",@"baby_id":@"2"} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"获取备注成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    */
    /*
    //修改宝宝备注
    [[HttpService sharedInstance] updateBabyRemark:@{@"uid":@"2",@"baby_id":@"2",@"alias":@"1", @"remark":@"3"} completionBlock:^(id object) {
         [SVProgressHUD showSuccessWithStatus:@"修改备注成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    */
 
    
   
    
    

    if ([[UIScreen mainScreen] bounds].size.height < 500) {
        _segScrollView.contentSize = CGSizeMake(320*3, _segScrollView.bounds.size.height-100);
    }
    else
    {
    _segScrollView.contentSize = CGSizeMake(320*3, _segScrollView.bounds.size.height);
    }
    
    [_summaryTableView registerNibWithName:@"SummaryCell" reuseIdentifier:@"Cell"];
    [_segScrollView addSubview:_summaryView];
    
    [_dynamicListTableView clearSeperateLine];
    [_dynamicListTableView registerNibWithName:@"BabyPersonalCell" reuseIdentifier:@"Celler"];
    _dynamicListView.frame = CGRectMake(320, 0, 320, _segScrollView.bounds.size.height);
    [_segScrollView addSubview:_dynamicListView];
    
    [_dynamicFullListTableView clearSeperateLine];
    [_dynamicFullListTableView registerNibWithName:@"BabyPersonalCell" reuseIdentifier:@"Celler"];
    _dynamicListFullView.frame = CGRectMake(320, 0, 320, _segFullScrollView.bounds.size.height);
    [_segFullScrollView addSubview:_dynamicListFullView];
    
    
    _heightAndWeightTableView.frame = CGRectMake(320*2, 0, 320, _segScrollView.bounds.size.height);
    
    
    
    
    NALLabelsMatrix *naLabelsMatrix = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake(10, 50, 300, 100) andColumnsWidths:[[NSArray alloc] initWithObjects:@90,@72,@72,@72, nil]];
    naLabelsMatrix.backgroundColor = [UIColor whiteColor];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"日期", @"身高(cm)", @"体重(kg)",@"体型", nil]];
    
    
     //获取宝宝成长记录
     [[HttpService sharedInstance] getBabyGrowRecord:@{@"baby_id":curBaby_id,
                                                       @"offset":@"0",
                                                       @"pagesize":@"10",
                                                       @"uid":users.uid}
                                     completionBlock:^(id object) {
                                         if (![[object objectForKey:@"result"] isEqual:[NSNull null]]) {
                                             for (int i=0; i<[[object objectForKey:@"result"] count]; i++) {
                                                 [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:[[[object objectForKey:@"result"] objectAtIndex:i] objectForKey:@"add_time"],[[[object objectForKey:@"result"] objectAtIndex:i] objectForKey:@"height"], [[[object objectForKey:@"result"] objectAtIndex:i] objectForKey:@"weight"],@"完美体型", nil]];
                                             }
                                             
                                             
                                         }
                                         
                                         
                                         [_heightAndWeight addSubview:naLabelsMatrix];
                                         
                                         
                                         
     } failureBlock:^(NSError *error, NSString *responseString) {
         NSString * msg = responseString;
         if (error) {
             msg = @"加载失败";
         }
         [SVProgressHUD showErrorWithStatus:msg];
     }];
    
    [_hAndwTableView setTableHeaderView:_heightAndWeight];
    [_segScrollView addSubview:_heightAndWeightTableView];
    
   
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
- (void)HMSegmentedControlInitMethodFull
{
    NSString *dy =[NSString stringWithFormat:@"动态(%i)",234];
    segMentedControlFull = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"简介",dy,@"身高体重"]];
    segMentedControlFull.font = [UIFont systemFontOfSize:15];
    segMentedControlFull.textColor = [UIColor darkGrayColor];
    segMentedControlFull.selectedTextColor = [UIColor colorWithRed:104.0/225.0 green:193.0/255.0 blue:14.0/255.0 alpha:1.0];
    [segMentedControlFull setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [segMentedControlFull setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [segMentedControlFull setSelectionIndicatorHeight:1.0];
    [segMentedControlFull setSelectionIndicatorColor:[UIColor colorWithRed:104.0/255.0 green:193.0/255.0 blue:14.0/255.0 alpha:1.0]];
    segMentedControlFull.frame = CGRectMake(0, 0, _tabSelectionFullBar.bounds.size.width, _tabSelectionFullBar.bounds.size.height);
    segMentedControlFull.selectedSegmentIndex = 1;
    [_segFullScrollView setContentOffset:CGPointMake(segMentedControlFull.selectedSegmentIndex*320, 0)];
    segMentedControlFull.tag = 646;
    [segMentedControlFull addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [_tabSelectionFullBar addSubview:segMentedControlFull];
}
- (void)changePage:(HMSegmentedControl *)segBtn
{
    int curPage = segBtn.selectedSegmentIndex;
    if (segBtn.tag != 646) {
        
        [_segScrollView setContentOffset:CGPointMake(curPage*320, 0)];
    }
    else
    {
        [_segFullScrollView setContentOffset:CGPointMake(curPage*320, 0)];
    }

}

- (void)showList:(UIBarButtonItem *)Btn
{
    if (!isRemarksBtnShown) {
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
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    DDLogVerbose(@"%@",NSStringFromClass([scrollView class]));
    if(![scrollView isKindOfClass:[UITableView class]])
    {
        int curPage = scrollView.bounds.origin.x/320;
        [segMentedControl setSelectedSegmentIndex:curPage animated:YES];
        [segMentedControlFull setSelectedSegmentIndex:curPage animated:YES];
    }
}

#pragma mark - UITableView Delegate and DataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _summaryTableView) {
        return [summaryKey count];
    }
    else
    {
        if (_babyPersonalDyArray!=nil) {
             return [_babyPersonalDyArray count];
        }
       else
       {
           return 0;
       }
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _summaryTableView) {
        static NSString *identify = @"Cell";
        SummaryCell *cell = (SummaryCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        
         UserInfo *users = [[UserDefault sharedInstance] userInfo];
        
        cell.summaryKeyLabel.text = [summaryKey objectAtIndex:indexPath.row];
        cell.summaryValueField.delegate = self;
        cell.summaryValueField.tag = indexPath.row + 999;
        cell.summaryValueField.enabled = NO;
        cell.sexImgView.hidden = YES;
        
        //获取宝宝信息
        [[HttpService sharedInstance] getBabyInfo:@{@"baby_id":curBaby_id} completionBlock:^(id object) {
            summaryValue = [object objectForKey:@"result"];
            
            summaryDic = [summaryValue objectAtIndex:0];
            
            _babyInfo.avatar = [summaryDic objectForKey:@"avatar"];
            _babyInfo.uid = [summaryDic objectForKey:@"uid"];
            _babyInfo.fid = [summaryDic objectForKey:@"fid"];
            _babyInfo.mid = [summaryDic objectForKey:@"mid"];
            _babyInfo.baby_name = [summaryDic objectForKey:@"baby_name"];
            _babyInfo.sex = [summaryDic objectForKey:@"sex"];
            _babyInfo.birthDate = [summaryDic objectForKey:@"birthday"];
            _babyInfo.nickName = [summaryDic objectForKey:@"nickname"];
            _babyInfo.country = [summaryDic objectForKey:@"country"];
            _babyInfo.province = [summaryDic objectForKey:@"province"];
            _babyInfo.city = [summaryDic objectForKey:@"city"];
            _babyInfo.sex = [summaryDic objectForKey:@"sex"];
            _babyInfo.birth_height = [summaryDic objectForKey:@"birth_height"];
            _babyInfo.birth_weight = [summaryDic objectForKey:@"birth_weight"];
            
            _monButton.enabled = [[summaryDic objectForKey:@"mid"] intValue] == 0 ? YES : NO;
            _dadButton.enabled = [[summaryDic objectForKey:@"fid"] intValue] == 0 ? YES : NO;
            
            if ([[summaryDic objectForKey:@"mid"] isEqualToString:users.uid] || [[summaryDic objectForKey:@"fid"] isEqualToString:users.uid]) {
                cell.summaryValueField.enabled = YES;
                
            }
            
            
            
            if ([[summaryDic objectForKey:@"background"] isEqual:[NSNull null]]) {
                _babyBackgroundImgView.image = [UIImage imageNamed:@"baby_4-bg.png"];
            }
            else
            {
                _babyBackgroundImgView.image = [UIImage imageWithContentsOfFile:[summaryDic objectForKey:@"background"]];
            }
            _babyAvatarImgView.image = [UIImage imageWithContentsOfFile:[summaryDic objectForKey:@"avatar"]];
            
            if (indexPath.row == 3) {
                cell.sexImgView.hidden = NO;
                cell.sexImgView.image = [UIImage imageNamed:[[summaryDic objectForKey:@"sex"] intValue] == 1 ? @"main_boy.png" : @"main_girl.png"];
                cell.summaryValueField.text = nil;
                cell.summaryValueField.text = [[summaryDic objectForKey:@"sex"] intValue] == 1 ? @"男" : @"女";
            }
            _babyAvatarImgView.image = [UIImage imageWithContentsOfFile:[summaryDic objectForKey:@"avatar"]];
            if (indexPath.row == 0) {
                cell.summaryValueField.text = nil;
                cell.summaryValueField.text = [summaryDic objectForKey:@"nickname"];
            }
            if (indexPath.row == 1) {
                cell.summaryValueField.text = nil;
                cell.summaryValueField.text = [summaryDic objectForKey:@"baby_name"];
            }
            if (indexPath.row == 2) {
                cell.summaryValueField.text = nil;
                cell.summaryValueField.text = [summaryDic objectForKey:@"birthday"];
            }
            if (indexPath.row == 4) {
                cell.summaryValueField.text = nil;
                cell.summaryValueField.text = [summaryDic objectForKey:@"city"];
            }
            if (indexPath.row == 5) {
                cell.summaryValueField.text = nil;
                cell.summaryValueField.text = [summaryDic objectForKey:@"birth_height"];
            }
            if (indexPath.row == 6) {
                cell.summaryValueField.text = nil;
                cell.summaryValueField.text = [summaryDic objectForKey:@"birth_weight"];
            }
            
             if (!_dadButton.enabled) {
             
             [[HttpService sharedInstance] getUserInfo:@{@"uid":[[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"fid"]} completionBlock:^(id obj) {
             [_dadButton setImage:[UIImage imageWithContentsOfFile:[[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]] forState:UIControlStateNormal];
             } failureBlock:^(NSError *error, NSString *responseString) {
             
             }];
             
             }
             if (!_monButton.enabled) {
             
             [[HttpService sharedInstance] getUserInfo:@{@"uid":[[[object objectForKey:@"result"] objectAtIndex:0] objectForKey:@"mid"]} completionBlock:^(id obj) {
             [_monButton setImage:[UIImage imageWithContentsOfFile:[[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]] forState:UIControlStateNormal];
             } failureBlock:^(NSError *error, NSString *responseString) {
                 
             }];
             }
        } failureBlock:^(NSError *error, NSString *responseString) {
            [SVProgressHUD showErrorWithStatus:responseString];
        }];
        
        
        
        
        

       
//        cell.contentView.backgroundColor = [UIColor clearColor];
//        if (indexPath.row == 3) {
//            
//            cell.summaryValueLabel.frame = CGRectMake(cell.bounds.size.width-120, 8, 81, 21);
//            UIImageView *sexImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.summaryValueLabel.frame.origin.x+84, 13, 12, 14)];
//            if ([cell.summaryValueLabel.text isEqualToString:@"男"]) {
//                sexImgView.image = [UIImage imageNamed:@"main_boy.png"];
//            }
//            else
//            {
//                sexImgView.image = [UIImage imageNamed:@"main_girl.png"];
//            }
//            [cell.contentView addSubview:sexImgView];
//            
//        }
        return cell;
    }
    else
    {
        BabyPersonalCell * dynamicCell = (BabyPersonalCell *)[tableView dequeueReusableCellWithIdentifier:@"Celler"];
        
        
        
        return dynamicCell;

    }
   
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _dynamicListTableView) {
         DDLogInfo(@"%i",indexPath.row);
        if (indexPath.row == 2) {
            self.view = _fullView;
            [self HMSegmentedControlInitMethodFull];
            [_dynamicFullListTableView setContentOffset:CGPointMake(0, 0) animated:YES];
            isFullList = YES;
            //_fullView.hidden = NO;
            //_inStatusView.hidden = YES;
            
        }
        if (indexPath.row == 0 || indexPath.row == 1) {
            self.view = _inStatusView;
            //_fullView.hidden = YES;
            //_inStatusView.hidden = NO;
        }
    }
    if (tableView == _dynamicFullListTableView) {
        if (indexPath.row == 0) {
            self.view = _inStatusView;
            [_dynamicListTableView setContentOffset:CGPointMake(0, 0) animated:YES];
            isFullList = NO;
            //_fullView.hidden = YES;
            //_inStatusView.hidden = NO;
        }
    }
    else
    {
        if (indexPath.row == 1) {
            self.view = _fullView;
            [self HMSegmentedControlInitMethodFull];
            [_dynamicFullListTableView setContentOffset:CGPointMake(0, 0) animated:YES];
            isFullList = YES;
            //_fullView.hidden = NO;
            //_inStatusView.hidden = YES;
            
        }
    }
   
}
*/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] init];
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

- (IBAction)isYaoQing:(id)sender
{
    _yaoQingbgView.hidden = NO;
    if (sender == _monButton)
    {
        
    }
    if (sender == _dadButton)
    {
    
    }
//    if ([_monButton])
//    {
//        _yaoQingbgView.hidden = NO;
//        if (sender == _monButton)
//        {
//            
//        }
//       
//    }
//    if ([_dadButton.titleLabel.text isEqualToString:@"邀请爸爸"])
//    {
//        _yaoQingbgView.hidden = NO;
//        if (sender == _dadButton)
//        {
//            
//        }
//        
//    }
    
}
- (IBAction)msgYaoQingButton:(id)sender
{
    
}

- (IBAction)weiXinYaoQingButton:(id)sender
{
    
}

- (IBAction)hideCurView:(id)sender
{
    _yaoQingbgView.hidden = YES;
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
- (IBAction)hideGayShareFullV:(id)sender
{
    _grayShareFullView.hidden = YES;
    isShareViewShown = NO;
}

- (IBAction)showAddHAndWPageVC:(id)sender
{
    AddHeightAndWeightViewController *addHeightAndWeightVC =[[AddHeightAndWeightViewController alloc] init];
    addHeightAndWeightVC.addCurBabyId = curBaby_id;
    [self.navigationController pushViewController:addHeightAndWeightVC animated:YES];
}

- (void)showRemarkVC
{
    [self showList:nil];
    RemarksViewController *remarksVC = [[RemarksViewController alloc] init];
    [self.navigationController pushViewController:remarksVC animated:YES];
}
- (void)specialCare
{
    [[HttpService sharedInstance] followBaby:@{@"uid":@"2",@"baby_id":@"2"} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    [self showList:nil];
}
#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    [textField becomeFirstResponder];
    CGRect rect;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        rect = CGRectMake(0.0f, 64.0f, self.view.frame.size.width, self.view.frame.size.height);
    }
    else
    {
        rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    }
    
    self.view.frame = rect;
    [UIView commitAnimations];
    
    UITextField *textF1 = (UITextField *)[_summaryTableView viewWithTag:999];
    UITextField *textF2 = (UITextField *)[_summaryTableView viewWithTag:1000];
    UITextField *textF3 = (UITextField *)[_summaryTableView viewWithTag:1001];
    UITextField *textF4 = (UITextField *)[_summaryTableView viewWithTag:1002];
    UITextField *textF5 = (UITextField *)[_summaryTableView viewWithTag:1003];
    UITextField *textF6 = (UITextField *)[_summaryTableView viewWithTag:1004];
    UITextField *textF7 = (UITextField *)[_summaryTableView viewWithTag:1005];
    
    if ([textF4.text isEqualToString:@"男"] || [textF4.text isEqualToString:@"女"]) {
         [self updateBabyInfoWithName:textF2.text Sex:[textF4.text isEqualToString:@"男"] ? @"1" : @"0" Birthday:textF3.text NickName:textF1.text Province:textF5.text City:textF5.text BirthH:textF6.text birthW:textF7.text];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"输入的数据有误，不能修改"];
        [_summaryTableView reloadData];
    }
    
   
    
    [textField resignFirstResponder];
    return YES;
}
#pragma mark 解决虚拟键盘挡住UITextField的方法
- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 216.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset;
    if (self.view.bounds.size.height > 490.0)
    {
        offset = frame.origin.y + 428 - 286;
    }
    else
    {
        offset = frame.origin.y + 500 - self.view.frame.size.height - 216;
    }
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    
    [UIView commitAnimations];
}

//更改宝宝信息
- (void)updateBabyInfoWithName:(NSString *)babyName Sex:(NSString *)babySex Birthday:(NSString *)babyBirthdate NickName:(NSString *)babyNickName Province:(NSString *)babyProvince City:(NSString *)babyCity BirthH:(NSString *)babyBirthH birthW:(NSString *)babyBirhW
{
    //更新宝宝信息
    [[HttpService sharedInstance] updateBabyInfo:@{@"baby_id":curBaby_id,
                                                   @"uid":_babyInfo.uid,
                                                   @"fid":_babyInfo.fid,
                                                   @"mid":_babyInfo.mid,
                                                   @"baby_name":babyName,
                                                   @"avatar":_babyInfo.avatar,
                                                   @"sex":babySex,
                                                   @"birthday":babyBirthdate,
                                                   @"nickname":babyNickName,
                                                   @"country":@"中国",
                                                   @"province":babyProvince,
                                                   @"city":babyCity,
                                                   @"birth_height":babyBirthH,
                                                   @"birth_weight":babyBirhW} completionBlock:^(id object) {
                                                       [_summaryTableView reloadData];
                                                       [SVProgressHUD showSuccessWithStatus:[object objectForKey:@"err_msg"]];
     } failureBlock:^(NSError *error, NSString *responseString) {
         NSString *msg = responseString;
         if (error) {
             msg = @"数据未变改";
         }
         [SVProgressHUD showErrorWithStatus:msg];
     }];
    
}
@end
