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
#import "DynamicCell.h"
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

@end

@implementation BabyHomePageViewController

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
    /*
    BabyInfo *baby = [[BabyInfo alloc] init];
    [[HttpService sharedInstance] getBabyInfo:@{@"baby_id":baby.baby_ID} completionBlock:^(id object) {
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    */
    /*
    [[HttpService sharedInstance] getBabyGrowRecord:@{@"baby_id":baby.baby_ID,
                                                      @"offset":@"1",
                                                      @"pagesize":@"10",
                                                      @"uid":baby.userInfo.uid}
                                    completionBlock:^(id object) {
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    */
    summaryKey = [NSArray arrayWithObjects:@"昵称",@"姓名",@"出生日期",@"性别",@"所在城市",@"出生身高",@"出生体重", nil];
    summaryValue = [NSArray arrayWithObjects:@"小龙",@"李小龙",@"2012-01-02",@"男",@"上海",@"51cm",@"3.456kg", nil];
    
    
    
    //    summaryDic = [[NSMutableDictionary alloc] initWithObjects:summaryValue forKeys:summaryKey];
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
    [_dynamicListTableView registerNibWithName:@"DynamicCell" reuseIdentifier:@"Celler"];
    _dynamicListView.frame = CGRectMake(320, 0, 320, _segScrollView.bounds.size.height);
    [_segScrollView addSubview:_dynamicListView];
    
    [_dynamicFullListTableView clearSeperateLine];
    [_dynamicFullListTableView registerNibWithName:@"DynamicCell" reuseIdentifier:@"Celler"];
    _dynamicListFullView.frame = CGRectMake(320, 0, 320, _segFullScrollView.bounds.size.height);
    [_segFullScrollView addSubview:_dynamicListFullView];
    
    
    _heightAndWeightTableView.frame = CGRectMake(320*2, 0, 320, _segScrollView.bounds.size.height);
    NALLabelsMatrix *naLabelsMatrix = [[NALLabelsMatrix alloc] initWithFrame:CGRectMake(10, 50, 300, 100) andColumnsWidths:[[NSArray alloc] initWithObjects:@90,@72,@72,@72, nil]];
    naLabelsMatrix.backgroundColor = [UIColor whiteColor];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"日期", @"身高(cm)", @"体重(kg)",@"体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [naLabelsMatrix addRecord:[[NSArray alloc] initWithObjects:@"2014-06-02", @"86", @"86",@"完美体型", nil]];
    [_heightAndWeight addSubview:naLabelsMatrix];
    
    [_hAndwTableView setTableHeaderView:_heightAndWeight];
    [_segScrollView addSubview:_heightAndWeightTableView];
}

- (void)HMSegmentedControlInitMethod
{
    NSString *dy =[NSString stringWithFormat:@"动态(%i)",234];
    segMentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"简介",dy,@"身高体重"]];
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
        return 10;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _summaryTableView) {
        static NSString *identify = @"Cell";
        SummaryCell *cell = (SummaryCell *)[tableView dequeueReusableCellWithIdentifier:identify];
        if (cell == nil) {
            cell = [[SummaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        cell.summaryKeyLabel.text = [summaryKey objectAtIndex:indexPath.row];
        cell.summaryValueLabel.text = [summaryValue objectAtIndex:indexPath.row];
        cell.contentView.backgroundColor = [UIColor clearColor];
        if (indexPath.row == 3) {
            
            cell.summaryValueLabel.frame = CGRectMake(cell.bounds.size.width-120, 8, 81, 21);
            UIImageView *sexImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.summaryValueLabel.frame.origin.x+84, 13, 12, 14)];
            if ([cell.summaryValueLabel.text isEqualToString:@"男"]) {
                sexImgView.image = [UIImage imageNamed:@"main_boy.png"];
            }
            else
            {
                sexImgView.image = [UIImage imageNamed:@"main_girl.png"];
            }
            [cell.contentView addSubview:sexImgView];
            
        }
        return cell;
    }
    else
    {
        DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Celler"];
        
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
   
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _dynamicListTableView) {
         DDLogInfo(@"%i",indexPath.row);
        if (indexPath.row == 1) {
            self.view = _fullView;
            [self HMSegmentedControlInitMethodFull];
            [_dynamicFullListTableView setContentOffset:CGPointMake(0, 0) animated:YES];
            isFullList = YES;
            //_fullView.hidden = NO;
            //_inStatusView.hidden = YES;
            
        }
        if (indexPath.row == 0) {
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
    [self showList:nil];
}
@end
