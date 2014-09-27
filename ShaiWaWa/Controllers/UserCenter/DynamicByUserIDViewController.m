//
//  DynamicByUserIDViewController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "DynamicByUserIDViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "UIViewController+BarItemAdapt.h"
#import "DynamicCell.h"
#import "DynamicDetailViewController.h"
#import "AppMacros.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "NSStringUtil.h"
#import "BabyRecord.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "TopicListOfDynamic.h"
#import "PublishImageView.h"
#import "ImageDisplayView.h"
@import MediaPlayer;
@interface DynamicByUserIDViewController ()
{
    NSMutableArray *dyArray;
}
@property (nonatomic,assign) int currentOffset;
@end

@implementation DynamicByUserIDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currentOffset = 0;
        dyArray = [[NSMutableArray alloc] init];
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

}


#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"我的动态";
    if(_user == nil)
    {
        _user = [[UserDefault sharedInstance] userInfo];
    }
    else
    {
        self.title = [NSString stringWithFormat:@"%@的动态",_user.username];
    }
    
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_dyTableView clearSeperateLine];
    [_dyTableView registerNibWithName:@"DynamicCell" reuseIdentifier:@"Cell"];
    [_dyTableView addHeaderWithTarget:self action:@selector(refreshData)];
    [_dyTableView addFooterWithTarget:self action:@selector(loadMoreData)];
    [_dyTableView headerBeginRefreshing];
}


- (void)refreshData
{
    _currentOffset = 0;
    [self showOnlyMyBabyDyList];
}

- (void)loadMoreData
{
    _currentOffset = [dyArray count];
    [self showOnlyMyBabyDyList];
}



- (void)showOnlyMyBabyDyList
{

    [[HttpService sharedInstance] getRecordByUserID:@{@"offset":[NSString stringWithFormat:@"%i",_currentOffset], @"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"uid":_user.uid} completionBlock:^(id object) {
        [_dyTableView headerEndRefreshing];
        [_dyTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            dyArray = object;
        }
        else
        {
            [dyArray addObjectsFromArray:object];
        }
        
        [_dyTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoadFinish", nil)];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error)
        {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_dyTableView headerEndRefreshing];
        [_dyTableView footerEndRefreshing];
    }];
    
}

- (void)showTopicDynamic:(UIButton *)sender
{
    NSString * topic = [sender titleForState:UIControlStateNormal];
    TopicListOfDynamic * vc = [[TopicListOfDynamic alloc] initWithNibName:nil bundle:nil];
    vc.topic = topic;
    [self push:vc];
    vc = nil;
}

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
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    NSIndexPath * indexPath = [_dyTableView indexPathForCell:cell];
    BabyRecord * record = dyArray[indexPath.row];
    //先判断是否有赞过，0：没有赞过，1：赞过
    if([record.is_like isEqualToString:@"0"])
    {
        [[HttpService sharedInstance] addLike:@{@"rid":record.rid,@"uid":user.uid} completionBlock:^(id object) {
            //成功之后设置为1，表示已经赞过
            record.is_like = @"1";
            [SVProgressHUD showSuccessWithStatus:@"谢谢您的参与."];
            
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
        [[HttpService sharedInstance] cancelLike:@{@"rid":record.rid,@"uid":user.uid} completionBlock:^(id object) {
            //成功之后设置为0，表示没有赞过
            record.is_like = @"0";
            [SVProgressHUD showSuccessWithStatus:@"取消赞成功."];
            
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



#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    BabyRecord * recrod = [dyArray objectAtIndex:indexPath.row];
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

    dynamicCell.addressLabel.text = recrod.address;
    dynamicCell.dyContentTextView.attributedText = [NSStringUtil makeTopicString:recrod.content];
    [dynamicCell.babyAvatarImageView sd_setImageWithURL:[NSURL URLWithString:recrod.avatar] placeholderImage:Default_Avatar];
    dynamicCell.babyNameLabel.text = recrod.baby_nickname;
    [dynamicCell.zanButton setTitle:recrod.like_count forState:UIControlStateNormal];
    [dynamicCell.commentBtn setTitle:recrod.comment_count forState:UIControlStateNormal];
    [dynamicCell.zanButton addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
    //显示赞用户列表
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
                ImageDisplayView * displayView = [[ImageDisplayView alloc] initWithFrame:self.navigationController.view.bounds withPath:path];
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
        PublishImageView * imageView = [[PublishImageView alloc] initWithFrame:dynamicCell.scrollView.bounds withPath:nil];
        [imageView setCloseHidden];
        [dynamicCell.scrollView addSubview:imageView];
        imageView = nil;
    }

    return dynamicCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] init];
    BabyRecord * record = dyArray[indexPath.row];
    dynamicDetailVC.babyRecord = record;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

#pragma mark -  UIScrollViewDelegate Methods
int _lastPosition;    //A variable define in headfile
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int currentPostion = scrollView.contentOffset.y;
    if (currentPostion - _lastPosition > 280) {
        _lastPosition = currentPostion;
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        //NSLog(@"ScrollUp now");
        
    }
    else if (_lastPosition - currentPostion > 280)
    {
        _lastPosition = currentPostion;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        //NSLog(@"ScrollDown now");
    }
}

@end
