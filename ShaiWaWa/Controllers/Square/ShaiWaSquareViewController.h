//
//  ShaiWaSquareViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "HMSegmentedControl.h"
#import "UICollectionViewWaterfallLayout.h"

@interface ShaiWaSquareViewController : CommonViewController<UIScrollViewDelegate,UICollectionViewDataSource, UICollectionViewDelegate>
{
    HMSegmentedControl *segMentedControl;
    //    BOOL isRightBtnSelected;
}
@property (strong, nonatomic) IBOutlet UIView *tabSelectionBar;
@property (strong, nonatomic) IBOutlet UIScrollView *segScrollView;
@property (nonatomic, strong) UICollectionView *collectionNew;
@property (nonatomic, strong) UICollectionView *collectionHot;

@end
