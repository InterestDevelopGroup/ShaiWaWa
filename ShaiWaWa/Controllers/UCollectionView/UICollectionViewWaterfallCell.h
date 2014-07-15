//
//  UICollectionViewWaterfallCell.h
//  Demo
//
//  Created by Nelson on 12/11/27.
//  Copyright (c) 2012年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionViewWaterfallCell : UICollectionViewCell
{
    UIView *releaseView;
}
@property (nonatomic, copy) NSString *displayString;
@property (nonatomic, retain) UIImageView *babyImgView;
@property (nonatomic, retain) UIButton *praiseButton;
@property (nonatomic, retain) UIButton *discussButton;
@property (nonatomic, copy) NSString *explainString;
@property (nonatomic, retain) UIView *releaseView;
@property (nonatomic, retain) UIImageView *releaseTouXiangImgView;
@property (nonatomic, copy) NSString *releaseNameString;
@property (nonatomic, copy) NSString *releaseTimeString;
@end
