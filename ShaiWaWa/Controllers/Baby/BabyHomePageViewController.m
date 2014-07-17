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
    UIBarButtonItem *rightBtn = [self customBarItem:@"baby_4-gengduo" action:@selector(showList:)];
    self.navigationItem.rightBarButtonItem =rightBtn;
    [self.view addSubview:_yaoQingbgView];
    isRightBtnSelected = NO;
    isShareViewShown = NO;
    isFullList = NO;
    self.view = _inStatusView;
    [self HMSegmentedControlInitMethod];
    [self HMSegmentedControlInitMethodFull];
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
@end
