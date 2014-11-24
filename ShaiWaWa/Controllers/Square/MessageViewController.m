//
//  MessageViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-13.
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
#import "NotificationMsg.h"
#import "UIImageView+WebCache.h"
#import "FriendHomeViewController.h"
#import "NSStringUtil.h"

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
    [self setLeftCusBarItem:@"square_back" action:@selector(backAction:)];
    
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


- (void)backAction:(id)sender
{
    if([_newestMsgArray count] > 0)
    {
        NSString * ids = @"";
        for(NotificationMsg * msg in _newestMsgArray)
        {
            if(![msg.notification_id isEqualToString:@"3"])
            {
                ids = [ids stringByAppendingFormat:@"%@,",msg.notification_id];
            }
        }
        
        if([ids length] != 0)
        {
            [SVProgressHUD showSuccessWithStatus:@"更新中..."];
            [[HttpService sharedInstance] updateSystemNotification:@{@"notification_id":ids,@"status":@"1"} completionBlock:^(id object) {
                
                NSLog(@"update success.");
                [self popVIewController];
            } failureBlock:^(NSError *error, NSString *responseString) {
                [SVProgressHUD showErrorWithStatus:@"更新失败."];
                
            }];
        }
        else
        {
            [self popVIewController];
        }
    }
    else
    {
        [self popVIewController];
    }
    
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
                 [SVProgressHUD showErrorWithStatus:@"暂时没有新消息."];
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
                 [SVProgressHUD showErrorWithStatus:@"暂时没有已读消息."];
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



- (void)agreeAction:(UIButton *)sender
{
    NotificationMsg * msg = [self getMessageByCellButton:sender];
    [[HttpService sharedInstance] verifyFriend:@{@"fid":msg.fid,@"type":@"2"} completionBlock:^(id object) {
        [self updateMsgStatus:@"1" msg:msg];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"操作失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)ignoreAction:(UIButton *)sender
{
    NotificationMsg * msg = [self getMessageByCellButton:sender];
    [[HttpService sharedInstance] verifyFriend:@{@"fid":msg.fid,@"type":@"3"} completionBlock:^(id object) {
        [self updateMsgStatus:@"1" msg:msg];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [self updateMsgStatus:@"1" msg:msg];
        NSString * msgstr = responseString;
        if (error) {
            msgstr = @"操作失败";
        }
        [SVProgressHUD showErrorWithStatus:msgstr];
        
    }];
}

- (void)refuseAction:(UIButton *)sender
{
    NotificationMsg * msg = [self getMessageByCellButton:sender];
    [[HttpService sharedInstance] verifyFriend:@{@"fid":msg.fid,@"type":@"4"} completionBlock:^(id object) {
        [self updateMsgStatus:@"1" msg:msg];
        [SVProgressHUD showSuccessWithStatus:@"添加成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"操作失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (NotificationMsg *)getMessageByCellButton:(UIButton *)sender
{
    
    MessageCell * cell;
    if([sender.superview.superview.superview isKindOfClass:[MessageCell class]])
    {
        cell = (MessageCell *)sender.superview.superview.superview;
    }
    else if([sender.superview.superview isKindOfClass:[MessageCell class]])
    {
        cell = (MessageCell *)sender.superview.superview;
    }
    else
    {
        cell = (MessageCell *)sender.superview;
    }
    
    NSIndexPath * indexPath = [_msgTableView indexPathForCell:cell];
    NotificationMsg * msg = _newestMsgArray[indexPath.row];
    return msg;
}

- (void)updateMsgStatus:(NSString *)status msg:(NotificationMsg *)msg
{
    [[HttpService sharedInstance] updateSystemNotification:@{@"notification_id":msg.notification_id,@"status":@"1"} completionBlock:^(id object) {
        
        if([_newestMsgArray containsObject:msg])
        {
            [_newestMsgArray removeObject:msg];
            [_msgTableView reloadData];
        }
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        
    }];
}


- (void)showHomePage:(UITapGestureRecognizer *)gesture
{
    UIImageView * imageView = (UIImageView *)gesture.view;
    MessageCell * cell ;
    NSLog(@"%@",NSStringFromClass([imageView.superview.superview.superview class]));
    if([imageView.superview.superview.superview isKindOfClass:[MessageCell class]])
    {
        cell = (MessageCell *)imageView.superview.superview.superview;
    }
    else if([imageView.superview.superview isKindOfClass:[MessageCell class]])
    {
        cell = (MessageCell *)imageView.superview.superview;
    }
    else
    {
        cell = (MessageCell *)imageView.superview;
    }
    
    NSIndexPath * indexPath ;
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        indexPath = [_msgTableView indexPathForCell:cell];
    }
    else
    {
        indexPath = [_haveReadMsgTableView indexPathForCell:cell];
    }
    
    if(indexPath == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"用户不存在"];
        return ;
    }
    
    NotificationMsg * msg ;
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        msg = [_newestMsgArray objectAtIndex:indexPath.row];
    }
    else
    {
        msg = [_haveReadMSGArray objectAtIndex:indexPath.row];
    }
    
    if(msg.requester_info == nil || [msg.requester_info isEqual:[NSNull null]])
    {
        [SVProgressHUD showErrorWithStatus:@"用户不存在"];
        return ;
    }
    
    FriendHomeViewController * vc = [[FriendHomeViewController alloc] initWithNibName:nil bundle:nil];
    vc.friendId = msg.requester_info[@"uid"];
    [self push:vc];
    vc = nil;
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
    NotificationMsg * msg ;
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        msg = _newestMsgArray[indexPath.row];
    }
    else
    {
        msg = _haveReadMSGArray[indexPath.row];
    }

    if (segMentedControl.selectedSegmentIndex == 0)
    {
        MessageCell * msgCell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];

        //计算时间
        msgCell.timeLabel.text = [NSStringUtil calculateTime:msg.add_time];
        switch ([msg.type intValue]) {
            case 1:     //动态被评论
                msgCell.agreeButton.hidden = YES;
                msgCell.ignoreButton.hidden = YES;
                msgCell.refuseButton.hidden = YES;
                msgCell.actionLabel.text = msg.content;
                if(msg.record_info != nil && [msg.record_info.images count] != 0)
                {
                    msgCell.receiveImgView.hidden = NO;
                    [msgCell.receiveImgView sd_setImageWithURL:[NSURL URLWithString:msg.record_info.images[0]]];
                }
                else
                {
                    msgCell.receiveImgView.hidden = YES;
                }

                break;
            case 2:     //动态被赞
                msgCell.agreeButton.hidden = YES;
                msgCell.ignoreButton.hidden = YES;
                msgCell.refuseButton.hidden = YES;
                msgCell.contentLabel.hidden = YES;
                msgCell.actionLabel.text = msg.content;
                if(msg.record_info != nil && [msg.record_info.images count] != 0)
                {
                    msgCell.receiveImgView.hidden = NO;
                    [msgCell.receiveImgView sd_setImageWithURL:[NSURL URLWithString:msg.record_info.images[0]]];
                }
                else
                {
                    msgCell.receiveImgView.hidden = YES;
                }

                break;
            case 3:     //申请成为好友
//                msgCell.sendNameLabel.text = msg.content;
                msgCell.receiveImgView.hidden = YES;
                //msgCell.timeLabel.hidden = YES;
                msgCell.actionLabel.text = msg.content;
                msgCell.contentLabel.text = msg.remark;
                
                [msgCell.agreeButton addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
                [msgCell.ignoreButton addTarget:self action:@selector(ignoreAction:) forControlEvents:UIControlEventTouchUpInside];
                [msgCell.refuseButton addTarget:self action:@selector(refuseAction:) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 4:     //好友申请被批准
                msgCell.agreeButton.hidden = YES;
                msgCell.ignoreButton.hidden = YES;
                msgCell.refuseButton.hidden = YES;
                msgCell.receiveImgView.hidden = YES;
                msgCell.contentLabel.hidden = YES;
                msgCell.actionLabel.text = msg.content;
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
                //msgCell.timeLabel.hidden = YES;
                msgCell.contentLabel.text = [NSString stringWithFormat:@"你关注的宝宝有新的动态"];
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
        msgCell.sendNameLabel.text = msg.username;
        if(msg.requester_info != nil && ![msg.requester_info isEqual:[NSNull null]])
        {
            [msgCell.sendImgView sd_setImageWithURL:msg.requester_info[@"avatar"] placeholderImage:Unkown_Avatar];
            
        }
        else
        {
            msgCell.sendImgView.image = Unkown_Avatar;
        }
        msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHomePage:)];
        msgCell.sendImgView.userInteractionEnabled = YES;
        [msgCell.sendImgView addGestureRecognizer:tap];
        return msgCell;
    }
    else
    {
        MessageCell * msgCell = (MessageCell *)[tableView dequeueReusableCellWithIdentifier:@"Celler"];
        NSString *typeId = msg.type;
        
        if ([typeId isEqualToString:@"1"]) {
            //动态被评论
            msgCell.actionLabel.text = @"评论了你的动态";
            
            
            if(msg.record_info != nil && [msg.record_info.images count] != 0)
            {
                msgCell.receiveImgView.hidden = NO;
                [msgCell.receiveImgView sd_setImageWithURL:[NSURL URLWithString:msg.record_info.images[0]]];
            }
            else
            {
                msgCell.receiveImgView.hidden = YES;
            }
        }
        if ([typeId isEqualToString:@"2"]) {
            //动态被赞
            msgCell.contentLabel.hidden = YES;
            msgCell.actionLabel.text = @"赞了你的动态";
            if(msg.record_info != nil && [msg.record_info.images count] != 0)
            {
                msgCell.receiveImgView.hidden = NO;
                [msgCell.receiveImgView sd_setImageWithURL:[NSURL URLWithString:msg.record_info.images[0]]];
            }
            else
            {
                msgCell.receiveImgView.hidden = YES;
            }
        }
        if ([typeId isEqualToString:@"3"]) {
            //申请成为好友
            msgCell.receiveImgView.hidden = YES;
            //msgCell.timeLabel.hidden = YES;
            msgCell.actionLabel.text = msg.content;
            msgCell.contentLabel.text = msg.remark;
        }
        if ([typeId isEqualToString:@"4"]) {
            //好友申请被批准
            msgCell.receiveImgView.hidden = YES;
            msgCell.contentLabel.hidden = YES;
            msgCell.actionLabel.text = @"同意了你的好友请求";
        }
        if ([typeId isEqualToString:@"5"]) {
            //好友申请被拒绝
            msgCell.receiveImgView.hidden = YES;
            msgCell.contentLabel.hidden = YES;
        }
        if ([typeId isEqualToString:@"6"]) {
            //自己的宝宝有新动态
            msgCell.receiveImgView.hidden = NO;
            msgCell.actionLabel.hidden = YES;
            //msgCell.timeLabel.hidden = YES;
        }
        if ([typeId isEqualToString:@"7"])
        {
            //特别关注的宝宝有新动态
            msgCell.sendNameLabel.text = @"系统消息";
            msgCell.sendNameLabel.textColor = [UIColor lightGrayColor];
            [msgCell.sendNameLabel setFrame:CGRectMake(74, 15, 80, 21)];

            msgCell.receiveImgView.hidden = YES;
            msgCell.actionLabel.hidden = YES;
            //msgCell.timeLabel.hidden = YES;
            msgCell.contentLabel.text = [NSString stringWithFormat:@"你关注的宝宝有新的动态"];
        }
        if ([typeId isEqualToString:@"8"]) {
            //被@了
 
            msgCell.contentLabel.hidden = YES;
            msgCell.actionLabel.text = @"在动态中@了你";

        }
        
        msgCell.agreeButton.hidden = YES;
        msgCell.ignoreButton.hidden = YES;
        msgCell.refuseButton.hidden = YES;
        msgCell.sendNameLabel.text = msg.username;
        if(msg.requester_info != nil && ![msg.requester_info isEqual:[NSNull null]])
        {
            [msgCell.sendImgView sd_setImageWithURL:msg.requester_info[@"avatar"] placeholderImage:Unkown_Avatar];
            
        }
        else
        {
            msgCell.sendImgView.image = Unkown_Avatar;
        }

        msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHomePage:)];
        msgCell.sendImgView.userInteractionEnabled = YES;
        [msgCell.sendImgView addGestureRecognizer:tap];
        
        
        //计算时间
        msgCell.timeLabel.text = [NSStringUtil calculateTime:msg.add_time];
        
        return msgCell;
    }
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        NotificationMsg *msg = _newestMsgArray[indexPath.row];
        //如果消息为好友请求，那么不作处理
        if ([msg.type intValue] != 3 ) {
            [[HttpService sharedInstance] updateSystemNotification:@{@"notification_id":msg.notification_id,@"status":@"1"} completionBlock:^(id object) {
                //点击该行调用网络接口，标记为已读，并且删除
                [_newestMsgArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            } failureBlock:nil];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
