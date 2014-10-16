//
//  ShaiWaSquareViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ShaiWaSquareViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "DynamicDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "BabyRecord.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "MJRefreshHeaderView.h"
#import "MJRefreshFooterView.h"
#import "MJRefresh.h"
#import "SquareCollectionCell.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "AppMacros.h"
#import "SDWebImageManager.h"
#import "VideoConvertHelper.h"
#import "FriendHomeViewController.h"
#import "PersonCenterViewController.h"
#import "BabyHomePageViewController.h"
#import "NSStringUtil.h"
#import "UICollectionViewWaterfallLayout.h"
@interface ShaiWaSquareViewController () <UICollectionViewDelegateWaterfallLayout>
@property (nonatomic,strong) NSMutableArray * newestDyArray;
@property (nonatomic,strong) NSMutableArray * hotDyArray;
@property (nonatomic,assign) int currentOffset;
@end

@implementation ShaiWaSquareViewController
@synthesize collectionNew,collectionHot;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _newestDyArray = [@[] mutableCopy];
        _hotDyArray = [@[] mutableCopy];
        _currentOffset = 0;
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
    self.title = @"晒娃广场";
    [self setLeftCusBarItem:@"square_back" action:nil];
//      UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    UICollectionViewWaterfallLayout *layout = [[UICollectionViewWaterfallLayout alloc] init];
    layout.itemWidth = 146;
    layout.columnCount = self.view.bounds.size.width / 146;
    layout.sectionInset = UIEdgeInsetsMake(1, 9, 1, 9);
    layout.delegate = self;
    [self HMSegmentedControlInitMethod];
    collectionNew = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, _segScrollView.frame.size.height) collectionViewLayout:layout];
    collectionNew.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    collectionNew.showsVerticalScrollIndicator = NO;
        
    collectionHot = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, _segScrollView.frame.size.height) collectionViewLayout:layout];
    collectionHot.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    collectionHot.showsVerticalScrollIndicator = NO;
    
    
    collectionNew.dataSource = self;
    collectionNew.delegate = self;
    
    collectionHot.dataSource = self;
    collectionHot.delegate = self;
    
    collectionNew.backgroundColor = [UIColor clearColor];
    UINib * nib = [UINib nibWithNibName:@"SquareCollectionCell" bundle:[NSBundle bundleForClass:[SquareCollectionCell class]]];
    [collectionNew registerNib:nib forCellWithReuseIdentifier:@"Cell"];
    __weak ShaiWaSquareViewController * weakSelf = self;
    [collectionNew addHeaderWithCallback:^{
        [weakSelf refresh];
    }];
    [collectionNew addFooterWithCallback:^{
        [weakSelf loadMore];
    }];
    //自动刷新
    [collectionNew headerBeginRefreshing];
    collectionHot.backgroundColor = [UIColor clearColor];
    [collectionHot registerNib:nib forCellWithReuseIdentifier:@"Cell"];
    
    
    [collectionHot addHeaderWithCallback:^{
        [weakSelf refresh];
    }];
    
    [collectionHot addFooterWithCallback:^{
        [weakSelf loadMore];
    }];
    
    
    UIView * view_1 = [UIView new];
    view_1.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.segScrollView.frame.size.height);
    view_1.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view_1 addSubview:collectionNew];
    UIView * view_2 = [UIView new];
    view_2.frame = CGRectMake(self.view.bounds.size.width, 0, self.view.bounds.size.width, self.segScrollView.frame.size.height);
    view_2.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view_2 addSubview:collectionHot];
    
    
    [_segScrollView addSubview:view_1];
    [_segScrollView addSubview:view_2];
    
    
    [_segScrollView setContentSize:CGSizeMake(2 * CGRectGetWidth(_segScrollView.frame), CGRectGetHeight(_segScrollView.frame))];
}

- (void)HMSegmentedControlInitMethod
{
    segMentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"最新",@"最热"]];
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
    
    //切换的时候，先判断当前是否有数据，如果没有数据，则刷新
    if(segBtn.selectedSegmentIndex == 0)
    {
        if([_newestDyArray count] == 0)
        {
            [collectionNew headerBeginRefreshing];
        }
    }
    else
    {
        if([_hotDyArray count] == 0)
        {
            [collectionHot headerBeginRefreshing];
        }
    }
    
}


- (void)refresh
{
    _currentOffset = 0;
    //先判断是获取最新还是最热
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        [self getNewRecrods];
    }
    else
    {
        [self getHotRecords];
    }
}

- (void)loadMore
{
    //先判断是获取最新还是最热
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        _currentOffset = [_newestDyArray count];
        [self getNewRecrods];
    }
    else
    {
        _currentOffset = [_hotDyArray count];
        [self getHotRecords];
    }
}

//获取最新的动态
- (void)getNewRecrods
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    
    [[HttpService sharedInstance] getSquareRecord:@{@"uid":user.uid,@"offset":[NSString stringWithFormat:@"%i",_currentOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"type":@"1"} completionBlock:^(id object) {
        [collectionNew headerEndRefreshing];
        [collectionNew footerEndRefreshing];
        
        if(_currentOffset == 0)
        {
            _newestDyArray = (NSMutableArray *)object;

        }
        else
        {
            [_newestDyArray addObjectsFromArray:object];
        }
        
        [collectionNew reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [collectionNew headerEndRefreshing];
        [collectionNew footerEndRefreshing];
        NSString * msg = responseString;
        if (error)
        {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];

}

//获取最热的动态
- (void)getHotRecords
{
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getSquareRecord:@{@"uid":user.uid,@"offset":[NSString stringWithFormat:@"%i",_currentOffset],@"pagesize":[NSString stringWithFormat:@"%i",CommonPageSize],@"type":@"2"} completionBlock:^(id object) {
        [collectionHot headerEndRefreshing];
        [collectionHot footerEndRefreshing];
        
        if (_currentOffset == 0) {
            _hotDyArray = (NSMutableArray *)object;
        }
        else
        {
            [_hotDyArray addObjectsFromArray:object];
        }
        [collectionHot reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [collectionHot headerEndRefreshing];
        [collectionHot footerEndRefreshing];
        NSString * msg = responseString;
        if (error)
        {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)showFriendInfo:(UITapGestureRecognizer *)gesture
{
    if(![gesture.view isKindOfClass:[UIImageView class]])
    {
        return ;
    }
    UIImageView * imageView = (UIImageView *)gesture.view;
    BabyRecord * record ;
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        record = _newestDyArray[imageView.tag];
    }
    else
    {
        record = _hotDyArray[imageView.tag];
    }
    
    
    /*
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    if(user != nil && [user.uid isEqualToString:record.uid])
    {
        PersonCenterViewController * vc = [[PersonCenterViewController alloc] initWithNibName:nil bundle:nil];
        [self push:vc];
        return ;
    }
    
    FriendHomeViewController * vc = [[FriendHomeViewController alloc] initWithNibName:nil bundle:nil];
    vc.friendId = record.uid;
    [self push:vc];
    vc = nil;
    */
    
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


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int curPage = scrollView.contentOffset.x/CGRectGetWidth(scrollView.frame);
    [segMentedControl setSelectedSegmentIndex:curPage animated:YES];
    
    //只有是滚动scrollview的时候才执行，因为collectionview滚动也会调用这个函数
    NSString * tmp = NSStringFromClass([scrollView class]);
    if([tmp isEqualToString:@"UIScrollView"])
    {
        //切换的时候，先判断当前是否有数据，如果没有数据，则刷新
        if(curPage == 0)
        {
            if([_newestDyArray count] == 0)
            {
                [collectionNew headerBeginRefreshing];
            }
        }
        else
        {
            if([_hotDyArray count] == 0)
            {
                [collectionHot headerBeginRefreshing];
            }
        }
    }
}

#pragma mark - UICollectionViewDataSource

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        return [_newestDyArray count];
    }
    else if(segMentedControl.selectedSegmentIndex == 1)
    {
        return [_hotDyArray count];
    }

    return 0;
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"Cell";
    SquareCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    BabyRecord * record;
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        record = _newestDyArray[indexPath.row];
    }
    else
    {
        record = _hotDyArray[indexPath.row];
    }
    
    if(record.video != nil && [record.video length] != 0)
    {
        if([[SDWebImageManager sharedManager] cachedImageExistsForURL:[NSURL URLWithString:record.video]])
        {
            [cell.babyImageView sd_setImageWithURL:[NSURL URLWithString:record.video]];
            
        }
        else
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage * image = [[VideoConvertHelper sharedHelper] getVideoThumb:record.video];
                [[SDWebImageManager sharedManager] saveImageToCache:image forURL:[NSURL URLWithString:record.video]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.babyImageView.image = image;
                });
            });
        }
    }
    else if([record.images count] > 0)
    {
        cell.babyImageView.hidden = NO;
        [cell.babyImageView sd_setImageWithURL:[NSURL URLWithString:record.images[0]] placeholderImage:[UIImage imageNamed:@"square_pic-1"]];
    }
    else
    {
//        cell.babyImageView.image = [UIImage imageNamed:@"square_pic-1"];
        cell.babyImageView.hidden = YES;
    }
    
    [cell.usernameLabel setText:record.baby_nickname];
    [cell.contentLabel setText:record.content];
    
        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:(record.avatar == nil ? @"" : record.avatar)] placeholderImage:Default_Avatar];
        cell.avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showFriendInfo:)];
        [cell.avatarImageView addGestureRecognizer:tap];
        cell.avatarImageView.tag = indexPath.row;
    cell.timeLabel.text = [NSStringUtil calculateTime:record.add_time];
    tap = nil;
    return cell;
}

////定义每个UICollectionView 的大小
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 210;
//}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewWaterfallLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BabyRecord * record;
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        record = _newestDyArray[indexPath.row];
    }
    else
    {
        record = _hotDyArray[indexPath.row];
    }
    //说明有图片
    if (record.images.count > 0 || (record.video != nil&& [record.video length] != 0)) {
//        return CGSizeMake(146, 240);
        return 240;
    }else
    {
//        return CGSizeMake(146, 240-161.0);
        return 79;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BabyRecord * record;
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        record = _newestDyArray[indexPath.row];
    }
    else
    {
        record = _hotDyArray[indexPath.row];
    }
        //说明有图片
    if (record.images.count > 0 || (record.video != nil&& [record.video length] != 0)) {
        return CGSizeMake(146, 240);
    }else
    {
        return CGSizeMake(146, 240-161.0);
    }
    
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 9, 1, 9);
}

#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    BabyRecord * record;
    if(segMentedControl.selectedSegmentIndex == 0)
    {
        record = _newestDyArray[indexPath.row];
    }
    else if(segMentedControl.selectedSegmentIndex == 1)
    {
        record = _hotDyArray[indexPath.row];
    }
    else
    {
        return ;
    }
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] initWithNibName:nil bundle:nil];
    dynamicDetailVC.babyRecord = record;
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
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
