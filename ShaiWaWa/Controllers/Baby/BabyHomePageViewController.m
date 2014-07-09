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

#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"小龙";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UIBarButtonItem *rightBtn = [self customBarItem:@"baby_4-gengduo" action:@selector(showList:)];
    self.navigationItem.rightBarButtonItem =rightBtn;
    isRightBtnSelected = NO;
    [self HMSegmentedControlInitMethod];
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

- (void)changePage:(HMSegmentedControl *)segBtn
{
    int curPage = segBtn.selectedSegmentIndex;
    [_segScrollView setContentOffset:CGPointMake(curPage*320, 0)];
}

- (void)showList:(UIBarButtonItem *)Btn
{
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int curPage = scrollView.bounds.origin.x/320;
    [segMentedControl setSelectedSegmentIndex:curPage animated:YES];
}

#pragma mark - UITableView Delegate and DataSources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [summaryKey count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
@end
