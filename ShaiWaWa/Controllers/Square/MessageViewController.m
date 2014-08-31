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
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "AppMacros.h"
@interface MessageViewController ()
{
    
}

@property (nonatomic,assign) int currentOffset;
@property (nonatomic,strong) NSMutableArray * newestMsgArray;
@property (nonatomic,strong) NSMutableArray * haveReadMSGArray;

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
    
    [self HMSegmentedControlInitMethod];
    
    _msgView.frame = CGRectMake(0, 0, CGRectGetWidth(_segScrollView.frame), CGRectGetHeight(_segScrollView.frame));
    _haveReadMsgView.frame = CGRectMake(CGRectGetWidth(_segScrollView.frame), 0, CGRectGetWidth(_segScrollView.frame), CGRectGetHeight(_segScrollView.frame));
    
    [_segScrollView addSubview:_haveReadMsgView];
    [_segScrollView addSubview:_msgView];
    
    _segScrollView.backgroundColor = [UIColor redColor];
    [_segScrollView setContentSize:CGSizeMake(CGRectGetWidth(_segScrollView.frame) * 2, CGRectGetHeight(_segScrollView.frame))];
    
    [_msgTableView clearSeperateLine];
    [_msgTableView registerNibWithName:@"MessageCell" reuseIdentifier:@"Cell"];
    //设置下拉刷新
    [_msgTableView addHeaderWithTarget:self action:@selector(refresh)];
    
    //设置上拉加载更多
    [_msgTableView setFooterPullToRefreshText:NSLocalizedString(@"PullTOLoad", nil)];
    [_msgTableView setFooterRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    [_msgTableView addFooterWithCallback:^{
        [self loadMore];
    }];
    
    //进入页面，自动刷新数据
    [_msgTableView headerBeginRefreshing];
    
    
    [_haveReadMsgTableView clearSeperateLine];
    [_haveReadMsgTableView registerNibWithName:@"MessageCell" reuseIdentifier:@"Celler"];
    
    //设置下拉刷新
    [_haveReadMsgTableView addHeaderWithCallback:^{
        [self refresh];
    }];
    
    //设置上拉加载更多
    [_haveReadMsgTableView addFooterWithCallback:^{
        [self loadMore];
    }];
    

    
    _newestMsgArray = [[NSMutableArray alloc] init];
    _haveReadMSGArray = [[NSMutableArray alloc] init];
   
    
   
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

- (void)refresh
{
    _currentOffset = 0;
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        [self getNewMessages];
    }
    else if(segMentedControl.selectedSegmentIndex == 1)
    {
        [self getReadedMessages];
    }
}

- (void)loadMore
{
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        _currentOffset = [_newestMsgArray count];
        [self getNewMessages];
    }
    else if(segMentedControl.selectedSegmentIndex == 1)
    {
        _currentOffset = [_haveReadMSGArray count];
        [self getReadedMessages];
    }
}

- (void)getNewMessages
{
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getSystemNotification:@{@"receive_uid":user.uid,@"offset":[NSString stringWithFormat:@"%i",_currentOffset], @"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"status":@"0"} completionBlock:^(id object)
     {
         [_msgTableView headerEndRefreshing];
         [_msgTableView footerEndRefreshing];
         if(_currentOffset == 0)
         {
             if(object == nil || object == [NSNull null])
             {
                 [SVProgressHUD showErrorWithStatus:@"暂时没有系统消息."];
                 return  ;
             }
             
             _newestMsgArray = (NSMutableArray *)object;
         }
         else
         {
             [_newestMsgArray addObjectsFromArray:object];
         }
         
         [_msgTableView reloadData];
         
     } failureBlock:^(NSError *error, NSString *responseString) {
         
         [_msgTableView headerEndRefreshing];
         [_msgTableView footerEndRefreshing];
         NSString * msg = responseString;
         if (error) {
             msg = NSLocalizedString(@"LoadError", nil);
         }
         [SVProgressHUD showErrorWithStatus:msg];
     }];

}

- (void)getReadedMessages
{
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getSystemNotification:@{@"receive_uid":user.uid,@"offset":[NSString stringWithFormat:@"%i",_currentOffset], @"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"status":@"1"} completionBlock:^(id object)
     {
         [_haveReadMsgTableView headerEndRefreshing];
         [_haveReadMsgTableView footerEndRefreshing];
         if(_currentOffset == 0)
         {
             if(object == nil || object == [NSNull null])
             {
                 [SVProgressHUD showErrorWithStatus:@"暂时没有系统消息."];
                 return  ;
             }
             
             _haveReadMSGArray = (NSMutableArray *)object;
         }
         else
         {
             [_haveReadMSGArray addObjectsFromArray:object];
         }

         [_haveReadMsgTableView reloadData];
         

     } failureBlock:^(NSError *error, NSString *responseString) {
         
         [_haveReadMsgTableView headerEndRefreshing];
         [_haveReadMsgTableView footerEndRefreshing];
         NSString * msg = responseString;
         if (error) {
             msg = NSLocalizedString(@"LoadError", nil);
         }
         [SVProgressHUD showErrorWithStatus:msg];
     }];
}

- (void)changePage:(HMSegmentedControl *)segBtn
{
    int curPage = segBtn.selectedSegmentIndex;
    [_segScrollView setContentOffset:CGPointMake(curPage*320, 0)];
    
    if(curPage == 0)
    {
        if([_newestMsgArray count] == 0)
        {
            [_msgTableView headerBeginRefreshing];
        }
    }
    else if(curPage == 1)
    {
        if([_haveReadMSGArray count] == 0)
        {
            [_haveReadMsgTableView headerBeginRefreshing];
        }
    }
}


//同意好友申请
- (void)agreeApply:(UIButton *)btn
{

    [[HttpService sharedInstance] verifyFriend:@{@"friend_id":@"1",@"type":@"2"} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    [_msgTableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:btn.tag-111 inSection:1] animated:YES];
}


//忽略好友申请
- (void)ignoreApply:(UIButton *)btn
{

}


//拒绝好友申请
- (void)refuseApply:(UIButton *)btn
{

    NSString *fId  = [[_newestMsgArray objectAtIndex:btn.tag-333] objectForKey:@"fid"];
    NSLog(@"%@",@{@"friend_id":fId,@"type":@"3"});
    
    [[HttpService sharedInstance] verifyFriend:@{@"friend_id":fId,@"type":@"3"} completionBlock:^(id object) {
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}



#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == _msgTableView) {
        
        return [_newestMsgArray count];
    }
    else
    {
       
         return [_haveReadMSGArray count];
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _msgTableView) {
        MessageCell * msgCell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
        UILabel *temp = [[UILabel alloc] init];
        switch ([[[_newestMsgArray objectAtIndex:indexPath.row] objectForKey:@"type"] intValue]) {
            case 1:     //动态被评论
                msgCell.agreeButton.hidden = YES;
                msgCell.ignoreButton.hidden = YES;
                msgCell.refuseButton.hidden = YES;
                msgCell.actionLabel.text = @"评论了你的动态";
                break;
            case 2:     //动态被赞
                msgCell.agreeButton.hidden = YES;
                msgCell.ignoreButton.hidden = YES;
                msgCell.refuseButton.hidden = YES;
                msgCell.contentLabel.hidden = YES;
                msgCell.actionLabel.text = @"赞了你的动态";
                break;
            case 3:     //申请成为好友
                msgCell.receiveImgView.hidden = YES;
                msgCell.timeLabel.hidden = YES;
                msgCell.actionLabel.text = @"请求加你为好友";
                
                msgCell.contentLabel.text = [[_newestMsgArray objectAtIndex:indexPath.row] objectForKey:@"remark"];
                
                break;
            case 4:     //好友申请被批准
                msgCell.agreeButton.hidden = YES;
                msgCell.ignoreButton.hidden = YES;
                msgCell.refuseButton.hidden = YES;
                msgCell.receiveImgView.hidden = YES;
                msgCell.contentLabel.hidden = YES;
                msgCell.actionLabel.text = @"同意了你的好友请求";
                break;
            case 5:     //好友申请被拒绝
                msgCell.agreeButton.hidden = YES;
                msgCell.ignoreButton.hidden = YES;
                msgCell.refuseButton.hidden = YES;
                msgCell.receiveImgView.hidden = YES;
                msgCell.contentLabel.hidden = YES;
                
                break;
            case 6:     //自己的宝宝有新动态
                msgCell.agreeButton.hidden = YES;
                msgCell.ignoreButton.hidden = YES;
                msgCell.refuseButton.hidden = YES;
                msgCell.receiveImgView.hidden = YES;
                msgCell.actionLabel.hidden = YES;
                msgCell.timeLabel.hidden = YES;
                break;
            case 7:     //特别关注的宝宝有新动态
                msgCell.sendNameLabel.text = @"系统消息";
                msgCell.sendNameLabel.textColor = [UIColor lightGrayColor];
                msgCell.agreeButton.hidden = YES;
                msgCell.ignoreButton.hidden = YES;
                msgCell.refuseButton.hidden = YES;
                msgCell.receiveImgView.hidden = YES;
                msgCell.actionLabel.hidden = YES;
                msgCell.timeLabel.hidden = YES;
                
                temp.text = @"张山";
                temp.textColor = [UIColor greenColor];
                //            NSString *babyName =
                msgCell.contentLabel.text = [NSString stringWithFormat:@"你关注的宝宝%@有新的动态",temp];
                break;
            case 8:     //被@了
                msgCell.agreeButton.hidden = YES;
                msgCell.ignoreButton.hidden = YES;
                msgCell.refuseButton.hidden = YES;
                msgCell.contentLabel.hidden = YES;
                msgCell.actionLabel.text = @"在动态中@了你";
                break;
            default:
                break;
        }


        msgCell.agreeButton.tag = indexPath.row+111;
        [msgCell.agreeButton addTarget:self action:@selector(agreeApply:) forControlEvents:UIControlEventTouchUpInside];
        msgCell.ignoreButton.tag = indexPath.row+222;
        [msgCell.ignoreButton addTarget:self action:@selector(ignoreApply:) forControlEvents:UIControlEventTouchUpInside];
        msgCell.refuseButton.tag = indexPath.row+333;
        [msgCell.refuseButton addTarget:self action:@selector(refuseApply:) forControlEvents:UIControlEventTouchUpInside];
        
        return msgCell;
    }
    else
    {
        MessageCell * msgCell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:@"Celler"];
        NSString *typeId = [[_haveReadMSGArray objectAtIndex:indexPath.row] objectForKey:@"type"];
        
        if ([typeId isEqualToString:@"1"]) {
            //动态被评论
            msgCell.agreeButton.hidden = YES;
            msgCell.ignoreButton.hidden = YES;
            msgCell.refuseButton.hidden = YES;
            msgCell.actionLabel.text = @"评论了你的动态";
        }
        if ([typeId isEqualToString:@"2"]) {
            //动态被赞
            msgCell.agreeButton.hidden = YES;
            msgCell.ignoreButton.hidden = YES;
            msgCell.refuseButton.hidden = YES;
            msgCell.contentLabel.hidden = YES;
            msgCell.actionLabel.text = @"赞了你的动态";
        }
        if ([typeId isEqualToString:@"3"]) {
            //申请成为好友
            msgCell.receiveImgView.hidden = YES;
            msgCell.timeLabel.hidden = YES;
            msgCell.actionLabel.text = @"请求加你为好友";
        }
        if ([typeId isEqualToString:@"4"]) {
            //好友申请被批准
            msgCell.agreeButton.hidden = YES;
            msgCell.ignoreButton.hidden = YES;
            msgCell.refuseButton.hidden = YES;
            msgCell.receiveImgView.hidden = YES;
            msgCell.contentLabel.hidden = YES;
            msgCell.actionLabel.text = @"同意了你的好友请求";
        }
        if ([typeId isEqualToString:@"5"]) {
            //好友申请被拒绝
            msgCell.agreeButton.hidden = YES;
            msgCell.ignoreButton.hidden = YES;
            msgCell.refuseButton.hidden = YES;
            msgCell.receiveImgView.hidden = YES;
            msgCell.contentLabel.hidden = YES;
        }
        if ([typeId isEqualToString:@"6"]) {
            //自己的宝宝有新动态
            msgCell.agreeButton.hidden = YES;
            msgCell.ignoreButton.hidden = YES;
            msgCell.refuseButton.hidden = YES;
            msgCell.receiveImgView.hidden = YES;
            msgCell.actionLabel.hidden = YES;
            msgCell.timeLabel.hidden = YES;
        }
        if ([typeId isEqualToString:@"7"]) {
            //特别关注的宝宝有新动态
            msgCell.sendNameLabel.text = @"系统消息";
            msgCell.sendNameLabel.textColor = [UIColor lightGrayColor];
            [msgCell.sendNameLabel setFrame:CGRectMake(74, 15, 80, 21)];
            msgCell.agreeButton.hidden = YES;
            msgCell.ignoreButton.hidden = YES;
            msgCell.refuseButton.hidden = YES;
            msgCell.receiveImgView.hidden = YES;
            msgCell.actionLabel.hidden = YES;
            msgCell.timeLabel.hidden = YES;
            
            NSString *babyName = @"博城";
            NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:babyName];
            [attrString addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleNone]} range:NSMakeRange(0, attrString.length)];
            msgCell.contentLabel.text = [NSString stringWithFormat:@"你关注的宝宝有新的动态"];
        }
        if ([typeId isEqualToString:@"8"]) {
            //被@了
            msgCell.agreeButton.hidden = YES;
            msgCell.ignoreButton.hidden = YES;
            msgCell.refuseButton.hidden = YES;
            msgCell.contentLabel.hidden = YES;
            msgCell.actionLabel.text = @"在动态中@了你";


        }
        
       
        
        return msgCell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",@{@"notification_id":[[_newestMsgArray objectAtIndex:indexPath.row] objectForKey:@"notification_id"],@"status":@"1"});
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] updateSystemNotification:
            @{@"notification_id":[[_newestMsgArray objectAtIndex:indexPath.row] objectForKey:@"notification_id"],@"status":@"1"} completionBlock:^(id object)
            {
                
                [[HttpService sharedInstance] getSystemNotification:@{@"receive_uid":user.uid,@"offset":@"0", @"pagesize":@"10"} completionBlock:^(id object)
                 {
                     
                     [_msgTableView reloadData];
                     [_haveReadMsgTableView reloadData];
                     [SVProgressHUD showSuccessWithStatus:@"获取消息列表完成"];
                 } failureBlock:^(NSError *error, NSString *responseString) {
                     [SVProgressHUD showErrorWithStatus:responseString];
                 }];
                
                    [_msgTableView reloadData];
                    [_haveReadMsgTableView reloadData];
                    [SVProgressHUD showSuccessWithStatus:@"消息已更新"];
            } failureBlock:^(NSError *error, NSString *responseString) {
                    [SVProgressHUD showErrorWithStatus:responseString];
     }];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(![scrollView isKindOfClass:[UITableView class]])
    {
        int curPage = scrollView.bounds.origin.x/320;
        [segMentedControl setSelectedSegmentIndex:curPage animated:YES];
        
        if(curPage == 0)
        {
            if([_newestMsgArray count] == 0)
            {
                [_msgTableView headerBeginRefreshing];
            }
        }
        else if(curPage == 1)
        {
            if([_haveReadMSGArray count] == 0)
            {
                [_haveReadMsgTableView headerBeginRefreshing];
            }
        }
    }
    
}


@end
