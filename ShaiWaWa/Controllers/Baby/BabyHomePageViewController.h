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
#import "BabyInfo.h"
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
@property (nonatomic, strong) BabyInfo *babyInfo;



@property (strong, nonatomic) IBOutlet UIView *yaoQingbgView;

@property (strong, nonatomic) IBOutlet UIView *dynamicListView;
@property (weak, nonatomic) IBOutlet UITableView *dynamicListTableView;
@property (weak, nonatomic) IBOutlet UIView *grayShareView;

@property (strong, nonatomic) IBOutlet UIView *fullView;
@property (strong, nonatomic) IBOutlet UIView *inStatusView;
@property (weak, nonatomic) IBOutlet UIScrollView *segFullScrollView;
@property (weak, nonatomic) IBOutlet UIView *grayShareFullView;

@property (weak, nonatomic) IBOutlet UITableView *dynamicFullListTableView;
@property (strong, nonatomic) IBOutlet UIView *dynamicListFullView;
@property (strong, nonatomic) IBOutlet UIView *heightAndWeight;
@property (strong, nonatomic) IBOutlet UIView *heightAndWeightTableView;
@property (weak, nonatomic) IBOutlet UITableView *hAndwTableView;

@property (weak, nonatomic) IBOutlet UIImageView *babyBackgroundImgView;
@property (weak, nonatomic) IBOutlet UIImageView *babyAvatarImgView;

- (IBAction)isYaoQing:(id)sender;
- (IBAction)showAddHAndWPageVC:(id)sender;
- (IBAction)hideGayShareFullV:(id)sender;
- (IBAction)hideGayShareV:(id)sender;
- (IBAction)msgYaoQingButton:(id)sender;
- (IBAction)weiXinYaoQingButton:(id)sender;
- (IBAction)hideCurView:(id)sender;

@end
