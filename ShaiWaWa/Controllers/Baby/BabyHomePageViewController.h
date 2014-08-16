//
//  BabyHomePageViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "HMSegmentedControl.h"

#import <MessageUI/MFMessageComposeViewController.h>
#import "TSLocateView.h"
@interface BabyHomePageViewController : CommonViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate>
{
    HMSegmentedControl *segMentedControl;
    NSMutableDictionary *summaryDic;
    NSArray *summaryKey;
    NSArray *summaryValue;
    BOOL isRightBtnSelected;
    BOOL isShareViewShown;
    BOOL isFullList;
    HMSegmentedControl *segMentedControlFull;
    UIButton *remarksBtn, *specialCareBtn;
    BOOL isRemarksBtnShown;
    NSString *curBaby_id;
    NSMutableArray *babyDyList;
    TSLocation *location;
    TSLocateView *locateView;
    
}
@property (strong, nonatomic) IBOutlet UIView *tabSelectionBar;
@property (weak, nonatomic) IBOutlet UIView *tabSelectionFullBar;

@property (strong, nonatomic) IBOutlet UIScrollView *segScrollView;
@property (strong, nonatomic) IBOutlet UIView *summaryView;
@property (strong, nonatomic) IBOutlet UITableView *summaryTableView;
@property (strong, nonatomic) IBOutlet UIButton *monButton;
@property (strong, nonatomic) IBOutlet UIButton *dadButton;
@property (strong, nonatomic) NSString *curBaby_id;

- (IBAction)isYaoQing:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *yaoQingbgView;
- (IBAction)msgYaoQingButton:(id)sender;

- (IBAction)weiXinYaoQingButton:(id)sender;
- (IBAction)hideCurView:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *dynamicListView;
@property (weak, nonatomic) IBOutlet UITableView *dynamicListTableView;
@property (weak, nonatomic) IBOutlet UIView *grayShareView;
- (IBAction)hideGayShareV:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *fullView;
@property (strong, nonatomic) IBOutlet UIView *inStatusView;
@property (weak, nonatomic) IBOutlet UIScrollView *segFullScrollView;
@property (weak, nonatomic) IBOutlet UIView *grayShareFullView;
- (IBAction)hideGayShareFullV:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *dynamicFullListTableView;
@property (strong, nonatomic) IBOutlet UIView *dynamicListFullView;
@property (strong, nonatomic) IBOutlet UIView *heightAndWeight;
@property (strong, nonatomic) IBOutlet UIView *heightAndWeightTableView;
@property (weak, nonatomic) IBOutlet UITableView *hAndwTableView;
- (IBAction)showAddHAndWPageVC:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *babyBackgroundImgView;
@property (weak, nonatomic) IBOutlet UIImageView *babyAvatarImgView;

@end
