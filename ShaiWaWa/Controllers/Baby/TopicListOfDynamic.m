//
//  TopicListOfDynamic.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-20.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TopicListOfDynamic.h"
#import "UIViewController+BarItemAdapt.h"
#import "DynamicCell.h"
#import "DynamicDetailViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "AppMacros.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "NSStringUtil.h"
#import "BabyRecord.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "PublishImageView.h"
#import "ImageDisplayView.h"
#import "BabyHomePageViewController.h"
#import "ShareView.h"
#import "ShareManager.h"
#import "AudioView.h"
#import "PersonCenterViewController.h"
#import "FriendHomeViewController.h"
#import "PraiseViewController.h"
@import MediaPlayer;
@interface TopicListOfDynamic ()<UIActionSheetDelegate>
@property (nonatomic,assign) int currentOffset;
@property (nonatomic,strong) NSMutableArray * dyArray;
@property (nonatomic,assign) BOOL isShareViewShown;
@property (nonatomic,strong) ShareView * sv;
@property (nonatomic,strong) BabyRecord * selectedRecord;
@end

@implementation TopicListOfDynamic

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _currentOffset = 0;
        _isShareViewShown = NO;
        _dyArray = [@[] mutableCopy];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



#pragma mark - Private Methods
- (void)initUI
{

    self.title = _topic;
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_dynamicPageTableView clearSeperateLine];
    [_dynamicPageTableView registerNibWithName:@"DynamicCell" reuseIdentifier:@"Cell"];
    [_dynamicPageTableView addHeaderWithCallback:^{
        [self refresh];
    }];
    
    [_dynamicPageTableView addFooterWithCallback:^{
        [self loadMore];
    }];
    
    [_dynamicPageTableView headerBeginRefreshing];
    
    [self configShareView];
}

- (void)configShareView
{
    _isShareViewShown = NO;
    _sv = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
    
    __weak TopicListOfDynamic * weakSelf = self;
    [_sv setDeleteBlock:^(){
        
        weakSelf.grayShareView.hidden = YES;
        weakSelf.isShareViewShown = NO;
        [weakSelf deleteRecord:weakSelf.selectedRecord];
    }];
    
    [_sv setCollectionBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        weakSelf.isShareViewShown = NO;
        [weakSelf collectionRecord:weakSelf.selectedRecord];
    }];
    
    [_sv setReportBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        weakSelf.isShareViewShown = NO;
        
        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情",@"反动",@"敏感话题",@"其他", nil];
        [actionSheet showInView:weakSelf.view];
        actionSheet = nil;
        
    }];
    
    
    [_sv setWeiXinBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        weakSelf.isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeWeixiSession babyRecord:weakSelf.selectedRecord];
    }];
    
    [_sv setWeiXinCycleBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        weakSelf.isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeWeixiTimeline babyRecord:weakSelf.selectedRecord];
    }];
    
    [_sv setQzoneBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        weakSelf.isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeQQSpace babyRecord:weakSelf.selectedRecord];
    }];
    
    [_sv setXinLanWbBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        weakSelf.isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeSinaWeibo babyRecord:weakSelf.selectedRecord];
    }];
    [_shareView addSubview:_sv];
}

- (void)shareWityType:(ShareType)type babyRecord:(BabyRecord *)babyRecord
{
    if(babyRecord == nil) return;
    
    if(babyRecord.video != nil && [babyRecord.video length] != 0)
    {
        UIImage * image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:babyRecord.video];
        [[ShareManager sharePlatform] shareWithType:type withContent:babyRecord.content withImage:image];
    }
    else if([babyRecord.images count] > 0)
    {
        [[ShareManager sharePlatform] shareWithType:type withContent:babyRecord.content withImagePath:babyRecord.images[0]];
    }
    else
    {
        [[ShareManager sharePlatform] shareWithType:type withContent:babyRecord.content withImage:nil];
    }
}

- (void)deleteRecord:(BabyRecord *)babyRecord
{
    if(babyRecord == nil) return;
     UserInfo * users = [[UserDefault sharedInstance] userInfo];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] deleteRecord:@{@"uid":users.uid,@"rid":babyRecord.rid} completionBlock:^(id object) {
        if([_dyArray containsObject:babyRecord])
        {
            [_dyArray removeObject:babyRecord];
            [_dynamicPageTableView reloadData];
        }
        [SVProgressHUD showSuccessWithStatus:@"删除成功."];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"删除失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


- (void)collectionRecord:(BabyRecord *)babyRecord
{
    if(babyRecord == nil) return;
     UserInfo * users = [[UserDefault sharedInstance] userInfo];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] addFavorite:@{@"uid":users.uid,@"rid":babyRecord.rid} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"收藏成功."];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"收藏失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
        
    }];
}

- (void)reportRecord:(BabyRecord *)babyRecord type:(NSString *)type
{
    if(babyRecord == nil) return;
     UserInfo * users = [[UserDefault sharedInstance] userInfo];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] addReport:@{@"uid":users.uid,@"rid":babyRecord.rid,@"type":type,@"remark":@"举报动态"} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"举报成功."];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"举报失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
        
    }];
}




- (void)refresh
{
    _currentOffset = 0;
    [self getTopicRecod];
}

- (void)loadMore
{
    _currentOffset = [_dyArray count];
    [self getTopicRecod];
}


- (void)getTopicRecod
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    //NSLog(@"%@",[_topic stringByReplacingOccurrencesOfString:@"#" withString:@""]);
    [[HttpService sharedInstance] getRecordByTopic:@{@"topic":[_topic stringByReplacingOccurrencesOfString:@"#" withString:@""],@"offset":[NSString stringWithFormat:@"%i",_currentOffset], @"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"uid":user.uid} completionBlock:^(id object) {
        [_dynamicPageTableView headerEndRefreshing];
        [_dynamicPageTableView footerEndRefreshing];
        if(_currentOffset == 0)
        {
            _dyArray = (NSMutableArray *)object;
        }
        else
        {
            [_dyArray addObjectsFromArray:object];
        }
        
        [_dynamicPageTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoadFinish", nil)];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error)
        {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_dynamicPageTableView headerEndRefreshing];
        [_dynamicPageTableView footerEndRefreshing];
    }];

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
    NSIndexPath * indexPath = [_dynamicPageTableView indexPathForCell:cell];
    BabyRecord * record = _dyArray[indexPath.row];
    
    if([record.is_like isEqualToString:@"0"])
    {
        [[HttpService sharedInstance] addLike:@{@"rid":record.rid,@"uid":user.uid} completionBlock:^(id object) {
            record.is_like = @"1";
            record.like_count = [NSString stringWithFormat:@"%i",[record.like_count intValue] + 1];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:[record.top_3_likes count] + 1];
            [tempArr addObjectsFromArray:record.top_3_likes];
            //生成一个字典
            NSMutableDictionary *zanDict = [@{} mutableCopy];
            zanDict[@"uid"] = user.uid;
            zanDict[@"avatar"] = user.avatar == nil ? @"" : user.avatar;
            zanDict[@"username"] = @"";
            zanDict[@"rid"] = @"";
            zanDict[@"add_time"] = @"";
            [tempArr insertObject:zanDict atIndex:0];
            record.top_3_likes = (NSArray *)tempArr;
            [_dynamicPageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
            record.is_like = @"0";
            record.like_count = [NSString stringWithFormat:@"%i",[record.like_count intValue] - 1];
            //取出宝宝被点赞的前三个
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:record.top_3_likes];
            for (NSDictionary *dict in record.top_3_likes) {
                if ([dict[@"uid"] isEqualToString:user.uid]) {
                    [tempArr removeObject:dict];
                }
            }
            record.top_3_likes = (NSArray *)tempArr;
            [_dynamicPageTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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


- (void)showBabyHomePage:(UITapGestureRecognizer *)gesture
{
    if(![gesture.view isKindOfClass:[UIImageView class]])
    {
        return ;
    }
    
    UIImageView * imageView = (UIImageView *)gesture.view;
    DynamicCell * cell ;
    if([imageView.superview.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)imageView.superview.superview.superview.superview;
    }
    else if ([imageView.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)imageView.superview.superview.superview;
    }
    else
    {
        cell = (DynamicCell *)imageView.superview.superview;
    }
    
    NSIndexPath * indexPath = [_dynamicPageTableView indexPathForCell:cell];
    BabyRecord * record = [_dyArray objectAtIndex:indexPath.row];
    
    [SVProgressHUD showWithStatus:@"加载中..."];
    [[HttpService sharedInstance] getBabyInfo:@{@"baby_id":record.baby_id} completionBlock:^(id object) {
        [SVProgressHUD dismiss];
        BabyHomePageViewController * vc = [[BabyHomePageViewController alloc] initWithNibName:nil bundle:nil];
        vc.babyInfo = object;
        [self push:vc];
        vc = nil;
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"加载失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)showShareGrayView:(UIButton *)button
{
    
    UIButton * btn = (UIButton *)button;
    DynamicCell * cell;
    UserInfo * users = [[UserDefault sharedInstance] userInfo];
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
    NSIndexPath * indexPath = [_dynamicPageTableView indexPathForCell:cell];
    BabyRecord * record = _dyArray[indexPath.row];
    self.selectedRecord = record;
    if([record.uid isEqualToString:users.uid])
    {
        [_sv showDelBtn];
    }
    else
    {
        [_sv hideDelBtn];
    }
    
    
    
    if (!_isShareViewShown) {
        _grayShareView.hidden = NO;
        _isShareViewShown = YES;
    }
    else
    {
        _grayShareView.hidden = YES;
        _isShareViewShown = NO;
    }
}

- (void)showHomePage:(UITapGestureRecognizer *)gesture
{
    
    if(![gesture.view isKindOfClass:[UILabel class]])
    {
        return ;
    }
    UserInfo * users = [[UserDefault sharedInstance] userInfo];
    UILabel * label = (UILabel *)gesture.view;
    DynamicCell * cell ;
    if([label.superview.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)label.superview.superview.superview.superview;
    }
    else if ([label.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)label.superview.superview.superview;
    }
    else
    {
        cell = (DynamicCell *)label.superview.superview;
    }
    
    NSIndexPath * indexPath = [_dynamicPageTableView indexPathForCell:cell];
    BabyRecord * record = [_dyArray objectAtIndex:indexPath.row];
    if([record.uid isEqualToString:users.uid])
    {
        PersonCenterViewController * vc = [[PersonCenterViewController alloc] initWithNibName:nil bundle:nil];
        [self push:vc];
        vc = nil;
    }
    else
    {
        FriendHomeViewController * vc = [[FriendHomeViewController alloc] initWithNibName:nil bundle:nil];
        vc.friendId = record.uid;
        [self push:vc];
        vc = nil;
    }
    
}


- (void)showPraiseListVC:(UIButton *)sender
{
    
    UIButton * btn = (UIButton *)sender;
    DynamicCell * cell;
    
    if([btn.superview.superview.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)btn.superview.superview.superview.superview.superview;
    }
    else if([btn.superview.superview.superview.superview isKindOfClass:[DynamicCell class]])
    {
        cell = (DynamicCell *)btn.superview.superview.superview.superview;
    }
    else
    {
        cell = (DynamicCell *)btn.superview.superview.superview;
    }
    NSIndexPath * indexPath = [_dynamicPageTableView indexPathForCell:cell];
    BabyRecord * record = _dyArray[indexPath.row];
    
    
    PraiseViewController *praiseListVC = [[PraiseViewController alloc] init];
    praiseListVC.record = record;
    [self.navigationController pushViewController:praiseListVC animated:YES];
}



#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    BabyRecord * recrod = [_dyArray objectAtIndex:indexPath.row];
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
            //[btn addTarget:self action:@selector(showTopicDynamic:) forControlEvents:UIControlEventTouchUpInside];
            [dynamicCell.topicView addSubview:btn];
            btn = nil;
        }
    }
    else
    {
        dynamicCell.topicView.hidden = YES;
    }
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
    
    //添加头像点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBabyHomePage:)];
    dynamicCell.babyAvatarImageView.userInteractionEnabled = YES;
    [dynamicCell.babyAvatarImageView addGestureRecognizer:tap];
    tap = nil;
    
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

    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHomePage:)];
    [dynamicCell.whoLabel addGestureRecognizer:tapGesture];
    dynamicCell.whoLabel.userInteractionEnabled = YES;
    tapGesture = nil;
    
    dynamicCell.releaseTimeLabel.text = [NSStringUtil calculateTime:recrod.add_time];
    
    dynamicCell.babyNameLabel.text = recrod.baby_nickname;
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
    
    [dynamicCell.moreBtn addTarget:self action:@selector(showShareGrayView:) forControlEvents:UIControlEventTouchUpInside];
    
    if([recrod.top_3_likes count] > 0)
    {
        dynamicCell.likeUserView.hidden = NO;
        NSDictionary * userDic = recrod.top_3_likes[0];
        [dynamicCell.praiseUserFirstBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
        [dynamicCell.praiseUserFirstBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
        if([recrod.top_3_likes count] > 1)
        {
            userDic = recrod.top_3_likes[1];
            [dynamicCell.praiseUserSecondBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
            [dynamicCell.praiseUserSecondBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        if([recrod.top_3_likes count] > 2)
        {
            userDic = recrod.top_3_likes[2];
            [dynamicCell.praiseUserThirdBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
            [dynamicCell.praiseUserThirdBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
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
        PublishImageView * imageView = [[PublishImageView alloc] initWithFrame:dynamicCell.scrollView.bounds withPath:nil];
        [imageView setCloseHidden];
        [dynamicCell.scrollView addSubview:imageView];
        imageView = nil;
    }


    [[dynamicCell.contentView viewWithTag:20000] removeFromSuperview];
    if(recrod.audio != nil && [recrod.audio length] > 0)
    {
        
        AudioView * audioView = [[AudioView alloc] initWithFrame:CGRectMake(123, 180, 82, 50) withPath:recrod.audio];
        audioView.tag = 20000;
        [audioView setCloseHidden];
        [dynamicCell.contentView addSubview:audioView];
    }
    return dynamicCell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] init];
    BabyRecord * record = _dyArray[indexPath.row];
    dynamicDetailVC.babyRecord = record;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%i",buttonIndex);
    if(buttonIndex== actionSheet.cancelButtonIndex)
    {
        _selectedRecord = nil;
        return ;
    }
    
    NSString * type = [NSString stringWithFormat:@"%i",buttonIndex + 1];
    
    [self reportRecord:_selectedRecord type:type];
}

@end
