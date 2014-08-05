//
//  MessageViewController.m
//  ShaiWaWa
//
//  Created by x on 14-7-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MessageViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "MessageCell.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

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
    self.title = [NSString stringWithFormat:@"消息"];
    [self setLeftCusBarItem:@"square_back" action:nil];
    if ([[UIScreen mainScreen] bounds].size.height < 500) {
        _segScrollView.contentSize = CGSizeMake(320*2, _segScrollView.bounds.size.height-100);
    }
    else
    {
        _segScrollView.contentSize = CGSizeMake(320*2, _segScrollView.bounds.size.height);
    }
    [self HMSegmentedControlInitMethod];
    
    [_msgTableView clearSeperateLine];
    [_msgTableView registerNibWithName:@"MessageCell" reuseIdentifier:@"Cell"];
    
    [_segScrollView addSubview:_msgView];
    
    
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getSystemNotification:@{@"Receive_uid":user.uid,@"offset":@"1", @"pagesize":@"10"} completionBlock:^(id object)
    {
        [SVProgressHUD showSuccessWithStatus:@"获取消息列表完成"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
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
    MessageCell * msgCell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
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
    
    return msgCell;
    
}
- (void)HMSegmentedControlInitMethod
{
    segMentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"新消息",@"已读消息"]];
    segMentedControl.font = [UIFont systemFontOfSize:15];
    segMentedControl.textColor = [UIColor darkGrayColor];
    segMentedControl.selectedTextColor = [UIColor colorWithRed:104.0/225.0 green:193.0/255.0 blue:14.0/255.0 alpha:1.0];
    [segMentedControl setSelectionIndicatorLocation:HMSegmentedControlSelectionIndicatorLocationDown];
    [segMentedControl setSelectionStyle:HMSegmentedControlSelectionStyleFullWidthStripe];
    [segMentedControl setSelectionIndicatorHeight:1.0];
    [segMentedControl setSelectionIndicatorColor:[UIColor colorWithRed:104.0/255.0 green:193.0/255.0 blue:14.0/255.0 alpha:1.0]];
    segMentedControl.frame = CGRectMake(0, 0, _tabSelectionBar.bounds.size.width, _tabSelectionBar.bounds.size.height);
    segMentedControl.selectedSegmentIndex = 0;
    [_segScrollView setContentOffset:CGPointMake(segMentedControl.selectedSegmentIndex*320, 0)];
    [segMentedControl addTarget:self action:@selector(changePage:)
               forControlEvents:UIControlEventValueChanged];
    [_tabSelectionBar addSubview:segMentedControl];
}

- (void)changePage:(HMSegmentedControl *)segBtn
{
    int curPage = segBtn.selectedSegmentIndex;
    [_segScrollView setContentOffset:CGPointMake(curPage*320, 0)];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int curPage = scrollView.bounds.origin.x/320;
    [segMentedControl setSelectedSegmentIndex:curPage animated:YES];
}

@end
