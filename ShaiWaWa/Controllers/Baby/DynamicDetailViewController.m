//
//  DynamicDetailViewController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-17.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "DynamicDetailViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "PinLunCell.h"
#import "ShareView.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
#import "RecordComment.h"
#import "DynamicDetailCell.h"
#import "AppMacros.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "NSStringUtil.h"
#import "PublishImageView.h"
#import "ImageDisplayView.h"
#import "PraiseViewController.h"
#import "BabyHomePageViewController.h"
#import "FriendHomeViewController.h"
#import "PersonCenterViewController.h"
#import "AudioView.h"
#import "ShareView.h"
#import "ShareManager.h"
@import MediaPlayer;
@interface DynamicDetailViewController ()<UIActionSheetDelegate>

@property (nonatomic,strong) ShareView * sv;
@end

@implementation DynamicDetailViewController
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Methods
- (void)initUI
{
    _isShareViewShown = NO;
    self.title = @"动态详情";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_pinLunListTableView clearSeperateLine];
    [_pinLunListTableView registerNibWithName:@"PinLunCell" reuseIdentifier:@"PinLunCell"];
    [_pinLunListTableView registerNibWithName:@"DynamicDetailCell" reuseIdentifier:@"DynamicDetailCell"];
    UIImageView *scollBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 299, 145)];
    scollBgView.image = [UIImage imageNamed:@"square_pic-3.png"];
   
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"baby_4-bg-2.png"];
    [_pinLunListTableView setBackgroundView:bgImgView];
    
    _sv = [[ShareView alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
    
    __weak DynamicDetailViewController * weakSelf = self;
    [_sv setDeleteBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        weakSelf.isShareViewShown = NO;
        [weakSelf deleteRecord:weakSelf.babyRecord];
    }];
    
    [_sv setCollectionBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        weakSelf.isShareViewShown = NO;
        [weakSelf collectionRecord:weakSelf.babyRecord];
    }];
    
    [_sv setReportBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        weakSelf.isShareViewShown = NO;

        UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:weakSelf cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"色情",@"反动",@"敏感话题",@"其他", nil];
        [actionSheet showInView:weakSelf.view];
        actionSheet = nil;

    }];
    
    [_sv setQzoneBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        _isShareViewShown = NO;
        
        [weakSelf shareWityType:ShareTypeQQSpace babyRecord:_babyRecord];
    }];
    
    [_sv setXinLanWbBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        _isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeSinaWeibo babyRecord:_babyRecord];
    }];
    
    [_sv setWeiXinBlock:^(){
        weakSelf.grayShareView.hidden = YES;
        _isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeWeixiSession babyRecord:_babyRecord];
    }];
    
    [_sv setWeiXinCycleBlock:^{
        weakSelf.grayShareView.hidden = YES;
        _isShareViewShown = NO;
        [weakSelf shareWityType:ShareTypeWeixiTimeline babyRecord:_babyRecord];
    }];
    
    
    
    [_shareView addSubview:_sv];
    
    pinLunArray = [[NSMutableArray alloc] init];
    [_pinLunListTableView addHeaderWithTarget:self action:@selector(refresh)];
    [_pinLunListTableView setHeaderRefreshingText:NSLocalizedString(@"DataLoading", nil)];
    [_pinLunListTableView headerBeginRefreshing];

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
        [self popVIewController];
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


//下拉刷新数据
- (void)refresh
{
    [self getComments];
}


#pragma mark 请求评论列表
- (void)getComments
{
    //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] getCommentList:@{@"rid":_babyRecord.rid,@"offset":@"0",@"pagesize":@"200"} completionBlock:^(id object) {
        //[SVProgressHUD dismiss];
        //pinLunArray = [[[object reverseObjectEnumerator] allObjects] mutableCopy];
//        _commentOffset += pinLunArray.count;    //
        if (pinLunArray.count > 0) {
            [pinLunArray removeAllObjects];
        }
        [pinLunArray addObjectsFromArray:object];
        [_pinLunListTableView headerEndRefreshing];
        [_pinLunListTableView reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"获取评论失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
        [_pinLunListTableView headerEndRefreshing];
    }];
}



- (void)showShareGrayView
{
    [_pinLunContextTextField resignFirstResponder];
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    if([user.uid isEqualToString:_babyRecord.uid])
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

- (IBAction)hideGrayShareV:(id)sender
{
    _grayShareView.hidden = YES;
    _isShareViewShown = NO;
}

#pragma mark -点赞按钮
- (void)likeAction:(id)sender
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    if(user == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请先登录"];
        return ;
    }
    
    //先判断是否有赞过，0：没有赞过，1：赞过
    if([_babyRecord.is_like isEqualToString:@"0"])
    {
        [[HttpService sharedInstance] addLike:@{@"rid":_babyRecord.rid,@"uid":user.uid} completionBlock:^(id object) {
            //成功之后设置为1，表示已经赞过
            _babyRecord.is_like = @"1";
            _babyRecord.like_count = [NSString stringWithFormat:@"%i",[_babyRecord.like_count intValue] + 1];
            NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:[_babyRecord.top_3_likes count] + 1];
            [tempArr addObjectsFromArray:_babyRecord.top_3_likes];
            //生成一个字典
            NSMutableDictionary *zanDict = [@{} mutableCopy];
            zanDict[@"uid"] = user.uid;
            zanDict[@"avatar"] = user.avatar == nil ? @"" : user.avatar;
            zanDict[@"username"] = @"";
            zanDict[@"rid"] = @"";
            zanDict[@"add_time"] = @"";
            [tempArr insertObject:zanDict atIndex:0];
            _babyRecord.top_3_likes = (NSArray *)tempArr;
            [_pinLunListTableView reloadData];
            
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
        [[HttpService sharedInstance] cancelLike:@{@"rid":_babyRecord.rid,@"uid":user.uid} completionBlock:^(id object) {
            //成功之后设置为0，表示没有赞过
            _babyRecord.is_like = @"0";
            _babyRecord.like_count = [NSString stringWithFormat:@"%i",[_babyRecord.like_count intValue] - 1];
            //取出宝宝被点赞的前三个
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:_babyRecord.top_3_likes];
            for (NSDictionary *dict in _babyRecord.top_3_likes) {
                if ([dict[@"uid"] isEqualToString:user.uid]) {
                    [tempArr removeObject:dict];
                }
            }
            _babyRecord.top_3_likes = (NSArray *)tempArr;
            [_pinLunListTableView reloadData];
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


- (IBAction)pinLunEvent:(id)sender
{
    [_pinLunContextTextField resignFirstResponder];
    if([_pinLunContextTextField.text length] == 0)
    {
        return ;
    }
    
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] addComment:@{@"rid":_babyRecord.rid,@"uid":users.uid,@"reply_id":@"",@"content":_pinLunContextTextField.text} completionBlock:^(id object) {
        //发布成功
        _pinLunContextTextField.text = @"";
        _babyRecord.comment_count = [NSString stringWithFormat:@"%i",[_babyRecord.comment_count intValue] + 1];
        [_pinLunListTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"评论成功,谢谢您的参与."];
        //重新刷新数据
        [_pinLunListTableView headerBeginRefreshing];
    } failureBlock:^(NSError *error, NSString *responseString) {
         NSString * msg = responseString;
         if (error) {
             msg = @"评论失败";
         }
         [SVProgressHUD showErrorWithStatus:msg];
    }];
}


- (void)showPraiseListVC:(id)sender
{
    PraiseViewController * vc = [[PraiseViewController alloc] initWithNibName:nil bundle:nil];
    vc.record = _babyRecord;
    [self push:vc];
    vc = nil;
}


- (void)showBabyHomePage:(UITapGestureRecognizer *)gesture
{
    if(![gesture.view isKindOfClass:[UIImageView class]])
    {
        return ;
    }
    
    BabyRecord * record = _babyRecord;
    
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


- (void)keyboardShow:(NSNotification *)notification
{
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //NSLog(@"%@",[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey]);
    CGRect beginRect = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //NSLog(@"%f",self.view.frame.origin.y);
    
    [UIView animateWithDuration:duration animations:^{
        
        float offset ;
        if(beginRect.size.height == endRect.size.height)
        {
            offset = - beginRect.size.height;
        }
        else
        {
            offset = beginRect.size.height - endRect.size.height;
        }
        self.view.frame = CGRectOffset(self.view.frame, 0,offset);
    }];
    
}

- (void)keyboardHide:(NSNotification *)notification
{
    float duration = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.view.frame = CGRectMake(0, [OSHelper iOS7]?64:0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
    }];
    
}


- (void)showPersonalHome:(UITapGestureRecognizer *)tap
{
    UILabel * label = (UILabel *)tap.view;
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    PinLunCell * cell;
    if([label.superview.superview.superview isKindOfClass:[PinLunCell class]])
    {
        cell = (PinLunCell *)label.superview.superview.superview;
    }
    else if([label.superview.superview isKindOfClass:[PinLunCell class]])
    {
        cell = (PinLunCell *)label.superview.superview;
    }
    else
    {
        cell = (PinLunCell *)label.superview;
    }
    NSIndexPath * indexPath = [_pinLunListTableView indexPathForCell:cell];
    RecordComment * comment = [pinLunArray objectAtIndex:indexPath.row];
    if([users.uid isEqualToString:comment.uid])
    {
        PersonCenterViewController * vc = [[PersonCenterViewController alloc] initWithNibName:nil bundle:nil];
        [self push:vc];
        vc = nil;
    }
    else
    {
        FriendHomeViewController * vc = [[FriendHomeViewController alloc] initWithNibName:nil bundle:nil];
        vc.friendId = comment.uid;
        [self push:vc];
        vc = nil;
    }
}

- (void)showHomePage:(UITapGestureRecognizer *)gesture
{
    
    UserInfo * users = [[UserDefault sharedInstance] userInfo];
    if([_babyRecord.uid isEqualToString:users.uid])
    {
        PersonCenterViewController * vc = [[PersonCenterViewController alloc] initWithNibName:nil bundle:nil];
        [self push:vc];
        vc = nil;
    }
    else
    {
        FriendHomeViewController * vc = [[FriendHomeViewController alloc] initWithNibName:nil bundle:nil];
        vc.friendId = _babyRecord.uid;
        [self push:vc];
        vc = nil;
    }
    
}


#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        float height = 285.0f;
        if([_babyRecord.images count] == 0 && (_babyRecord.video == nil || [_babyRecord.video length] == 0))
        {
            height -= 109;
        }
        
        /*
         if(babyRecord.address == nil || [babyRecord.address length] == 0)
         {
         height -= 17;
         }
         */
        return height;

    }
    else
    {
        return 45;
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }
    else
    {
        return [pinLunArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell ;
    if(indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DynamicDetailCell"];
        DynamicDetailCell * detailCell = (DynamicDetailCell *)cell;
        [detailCell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:_babyRecord.avatar] placeholderImage:Default_Avatar];

        //添加头像点击手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showBabyHomePage:)];
        detailCell.avatarImageView.userInteractionEnabled = YES;
        [detailCell.avatarImageView addGestureRecognizer:tap];
        tap = nil;
        
        NSString * who = _babyRecord.username;
        if([_babyRecord.sex isEqualToString:@"1"])
        {
            who = [NSString stringWithFormat:@"%@(爸爸)",who];
        }
        else if ([_babyRecord.sex isEqualToString:@"2"])
        {
            who = [NSString stringWithFormat:@"%@(妈妈)",who];
        }
        detailCell.whoLabel.text = who;
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showHomePage:)];
        [detailCell.whoLabel addGestureRecognizer:tapGesture];
        detailCell.whoLabel.userInteractionEnabled = YES;
        tapGesture = nil;
        detailCell.publishTimeLabel.text = [NSStringUtil calculateTime:_babyRecord.add_time];
        detailCell.birthdayLabel.text = [NSStringUtil calculateAge:_babyRecord.birthday];
        
        detailCell.babyNameLabel.text = _babyRecord.baby_nickname;
        if([_babyRecord.baby_alias length] != 0)
        {
            detailCell.babyNameLabel.text = _babyRecord.baby_alias;
        }
        
        detailCell.addressLabel.text = _babyRecord.address;
        if(_babyRecord.address == nil || [_babyRecord.address length] == 0)
        {
            detailCell.locationImageView.hidden = YES;
        }
        detailCell.contentTextView.attributedText = [NSStringUtil makeTopicString:_babyRecord.content];

        [detailCell.likeBtn setTitle:_babyRecord.like_count forState:UIControlStateNormal];
        
        if([_babyRecord.is_like isEqualToString:@"1"])
        {
            detailCell.likeBtn.selected = YES;
        }
        else
        {
            detailCell.likeBtn.selected = NO;
        }
        
        [detailCell.commentBtn setTitle:_babyRecord.comment_count forState:UIControlStateNormal];
        [detailCell.likeBtn addTarget:self action:@selector(likeAction:) forControlEvents:UIControlEventTouchUpInside];
  
        detailCell.publishTimeLabel.text = [NSStringUtil calculateTime:_babyRecord.add_time];
        [detailCell.moreBtn addTarget:self action:@selector(showShareGrayView) forControlEvents:UIControlEventTouchUpInside];
        
        //显示赞用户头像
        if([_babyRecord.top_3_likes count] > 0)
        {
            detailCell.likeView.hidden = NO;
            detailCell.praiseUserFirstBtn.hidden = NO;
            NSDictionary * userDic = _babyRecord.top_3_likes[0];
            [detailCell.praiseUserFirstBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
            [detailCell.praiseUserFirstBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
            if (_babyRecord.top_3_likes.count == 1) {
                detailCell.praiseUserSecondBtn.hidden = YES;
                detailCell.praiseUserThirdBtn.hidden = YES;
            }
            if([_babyRecord.top_3_likes count] > 1)
            {
                detailCell.praiseUserSecondBtn.hidden = NO;
                userDic = _babyRecord.top_3_likes[1];
                [detailCell.praiseUserSecondBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
                [detailCell.praiseUserSecondBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            if([_babyRecord.top_3_likes count] > 2)
            {
                detailCell.praiseUserThirdBtn.hidden = NO;
                userDic = _babyRecord.top_3_likes[2];
                [detailCell.praiseUserThirdBtn sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar"] == [NSNull null] ? @"":userDic[@"avatar"]] forState:UIControlStateNormal placeholderImage:Default_Avatar];
                [detailCell.praiseUserThirdBtn addTarget:self action:@selector(showPraiseListVC:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        else
        {
            detailCell.likeView.hidden = YES;
        }
        
        DynamicDetailCell * dynamicCell = detailCell;
        BabyRecord * recrod = _babyRecord;
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
            dynamicCell.scrollView.hidden = NO;
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
                dynamicCell.scrollView.hidden = NO;
                imageView = nil;
            }
            [dynamicCell.scrollView setContentSize:CGSizeMake([recrod.images count] * width, CGRectGetHeight(dynamicCell.scrollView.bounds))];
            
        }
        else
        {
            /*
            PublishImageView * imageView = [[PublishImageView alloc] initWithFrame:dynamicCell.scrollView.bounds withPath:nil];
            [imageView setCloseHidden];
            [dynamicCell.scrollView addSubview:imageView];
            imageView = nil;
            */
            dynamicCell.scrollView.hidden = YES;
        }
        
        if([recrod.images count] == 0 && (recrod.video == nil || [recrod.video length] == 0))
        {
            CGRect detailRect = dynamicCell.detailView.frame;
            detailRect.origin.y = 58;
            dynamicCell.detailView.frame = detailRect;
        }
        else
        {
            CGRect detailRect = dynamicCell.detailView.frame;
            detailRect.origin.y = 170;
            dynamicCell.detailView.frame = detailRect;
            
        }

        
        [[dynamicCell.contentView viewWithTag:20000] removeFromSuperview];
        if(_babyRecord.audio != nil && [_babyRecord.audio length] > 0)
        {
            CGRect rect = CGRectMake(123, 180, 82, 50);
            if([recrod.images count] == 0 && (recrod.video == nil || [recrod.video length] == 0))
            {
                rect = CGRectMake(123, 40, 82, 50);
            }

            
            AudioView * audioView = [[AudioView alloc] initWithFrame:rect withPath:_babyRecord.audio];
            audioView.tag = 20000;
            [audioView setCloseHidden];
            [dynamicCell.contentView addSubview:audioView];
        }

        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PinLunCell"];
        RecordComment * comment = pinLunArray[indexPath.row];
        PinLunCell * pinLunCell = (PinLunCell *)cell;
        pinLunCell.usernameLabel.text = comment.username?comment.username:@"";
        pinLunCell.contentLabel.text = comment.content?comment.content:@"";
        pinLunCell.addTimeLabel.text = [NSStringUtil calculateTime:comment.add_time];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPersonalHome:)];
        pinLunCell.usernameLabel.userInteractionEnabled = YES;
        [pinLunCell.usernameLabel addGestureRecognizer:tap];
        tap = nil;
    }
    
 
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark - UITextFieldDelegate Methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if([textField.text length] > 0)
    {
        [self pinLunEvent:nil];
    }
    
    return YES;
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"%i",buttonIndex);
    if(buttonIndex== actionSheet.cancelButtonIndex)
    {

        return ;
    }
    
    NSString * type = [NSString stringWithFormat:@"%i",buttonIndex + 1];
    
    [self reportRecord:_babyRecord type:type];
}



@end
