//
//  ShaiWaSquareViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ShaiWaSquareViewController.h"
#import "UIViewController+BarItemAdapt.h"
//#import "UICollectionViewWaterfallCell.h"
#import "DynamicDetailViewController.h"

@interface ShaiWaSquareViewController ()

@end

@implementation ShaiWaSquareViewController
@synthesize collectionNew,collectionHot;
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
    self.title = @"晒娃广场";
    [self setLeftCusBarItem:@"square_back" action:nil];
      UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    if ([[UIScreen mainScreen] bounds].size.height < 500) {
        _segScrollView.contentSize = CGSizeMake(320*2, _segScrollView.bounds.size.height-90);
        collectionNew = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, _segScrollView.bounds.size.height-90) collectionViewLayout:layout];
        
        collectionHot = [[UICollectionView alloc]initWithFrame:CGRectMake(320,0,self.view.bounds.size.width, _segScrollView.bounds.size.height-90) collectionViewLayout:layout];
    }
    else
    {
        _segScrollView.contentSize = CGSizeMake(320*2, _segScrollView.bounds.size.height);
        collectionNew = [[UICollectionView alloc]initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, _segScrollView.bounds.size.height) collectionViewLayout:layout];
        
        collectionHot = [[UICollectionView alloc]initWithFrame:CGRectMake(320,0,self.view.bounds.size.width, _segScrollView.bounds.size.height) collectionViewLayout:layout];
    }
    [self HMSegmentedControlInitMethod];
    
  
    
    collectionNew.dataSource = self;
    collectionNew.delegate = self;
    
    collectionHot.dataSource = self;
    collectionHot.delegate = self;
    
    collectionNew.backgroundColor = [UIColor clearColor];
    [collectionNew registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    
    collectionHot.backgroundColor = [UIColor clearColor];
    [collectionHot registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    [_segScrollView addSubview:collectionHot];
    [_segScrollView addSubview:collectionNew];
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
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int curPage = scrollView.bounds.origin.x/320;
    [segMentedControl setSelectedSegmentIndex:curPage animated:YES];
}

#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //    UICollectionViewWaterfallCell *cell =
    //    (UICollectionViewWaterfallCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELL_IDENTIFIER forIndexPath:indexPath];
    //
    //    cell.displayString = [NSString stringWithFormat:@"%d", indexPath.row];
    //    cell.explainString = [NSString stringWithFormat:@"这是第%d张", indexPath.row+1];
    //    cell.releaseNameString = @"张三";
    //    cell.releaseTimeString = @"1分钟前";
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIImageView *babyImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, cell.bounds.size.width-10, 121)];
    babyImgView.userInteractionEnabled = YES;
    babyImgView.image = [UIImage imageNamed:@"square_pic-1.png"];
    UIButton *praiseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *discussButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    praiseButton.frame = CGRectMake(cell.bounds.size.width-50, 1, 24, 24);
    [praiseButton setImage:[UIImage imageNamed:@"square_zan.png"] forState:UIControlStateNormal];
    discussButton.frame = CGRectMake(cell.bounds.size.width-30, 1, 24, 24);
    [discussButton setImage:[UIImage imageNamed:@"square_pinglun.png"] forState:UIControlStateNormal];
    [babyImgView addSubview:praiseButton];
    [babyImgView addSubview:discussButton];
    [cell.contentView addSubview:babyImgView];
    
    UITextView *explainTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height-75, cell.contentView.bounds.size.width, 30)];
    explainTextView.font = [UIFont systemFontOfSize:14];
    explainTextView.text =@"天使一般的宝宝。。。。。。";
    explainTextView.scrollEnabled = NO;
    explainTextView.editable = NO;
    explainTextView.showsHorizontalScrollIndicator = NO;
    explainTextView.showsVerticalScrollIndicator = NO;
    explainTextView.backgroundColor = [UIColor lightGrayColor];
    explainTextView.textColor = [UIColor whiteColor];
    //    explainTextView.textAlignment = NSTextAlignmentCenter;
    [cell.contentView addSubview:explainTextView];
    //cell.contentView.backgroundColor = [UIColor clearColor];
    
    UIView *releaseView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.bounds.size.height-45, cell.contentView.bounds.size.width, 47)];
//    releaseView.backgroundColor = [UIColor orangeColor];
    UIImageView *releaseTouXiangImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
    releaseTouXiangImgView.image = [UIImage imageNamed:@"square_pic-2.png"];
    UILabel *releaseNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 11, 80, 20)];
    UILabel *releaseTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 29, 80, 20)];
    releaseNameLabel.text = @"张三";
    releaseNameLabel.backgroundColor = [UIColor clearColor];
    releaseNameLabel.font = [UIFont systemFontOfSize:12];
    releaseTimeLabel.text = @"1分钟前";
    releaseTimeLabel.backgroundColor = [UIColor clearColor];
    releaseTimeLabel.font = [UIFont systemFontOfSize:10];
    [releaseView addSubview:releaseTouXiangImgView];
    [releaseView addSubview:releaseNameLabel];
    [releaseView addSubview:releaseTimeLabel];
    [cell.contentView addSubview:releaseView];
    return cell;
}

////定义每个UICollectionView 的大小
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 210;
//}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(146, 200);
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
//    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
//    cell.backgroundColor = [UIColor whiteColor];
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] init];
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
@end
