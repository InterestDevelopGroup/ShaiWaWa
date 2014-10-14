//
//  BabyHomePageViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "HMSegmentedControl.h"

#import <MessageUI/MFMessageComposeViewController.h>
#import "TSLocateView.h"
#import "BabyInfo.h"
@class BabyRemark;
@interface BabyHomePageViewController : CommonViewController<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate,UIActionSheetDelegate>
{
    HMSegmentedControl *segMentedControl;
    NSArray *summaryKey;
    BOOL isRightBtnSelected;
    BOOL isShareViewShown;
    BOOL isFullList;
    UIButton *remarksBtn, *specialCareBtn;
    BOOL isRemarksBtnShown;
    TSLocation *location;
    TSLocateView *locateView;
    
}
@property (strong, nonatomic) BabyRemark *remark;
@property (assign, nonatomic) BOOL isFromRemarkController;
@property (strong, nonatomic) IBOutlet UIView *tabSelectionBar;
@property (strong, nonatomic) IBOutlet UIScrollView *segScrollView;
@property (strong, nonatomic) IBOutlet UIView *summaryView;
@property (strong, nonatomic) IBOutlet UITableView *summaryTableView;
@property (strong, nonatomic) IBOutlet UIButton *monButton;
@property (strong, nonatomic) IBOutlet UIButton *dadButton;
@property (nonatomic, strong) BabyInfo *babyInfo;


@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (strong, nonatomic) IBOutlet UIView *yaoQingbgView;

@property (strong, nonatomic) IBOutlet UIView *dynamicListView;
@property (weak, nonatomic) IBOutlet UITableView *dynamicListTableView;
@property (weak, nonatomic) IBOutlet UIView *grayShareView;
@property (strong, nonatomic) IBOutlet UIView *inStatusView;
@property (strong, nonatomic) IBOutlet UIView *heightAndWeightTableView;
@property (weak, nonatomic) IBOutlet UIImageView *babyBackgroundImgView;
@property (weak, nonatomic) IBOutlet UIButton *babyAvatarImgView;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)changDisplayStyle:(UIButton *)sender;   //表格，折线图切换
- (IBAction)fullScreen:(UIButton *)sender;//全屏

- (IBAction)isYaoQing:(id)sender;
- (IBAction)showAddHAndWPageVC:(id)sender;
- (IBAction)hideGayShareFullV:(id)sender;
- (IBAction)hideGayShareV:(id)sender;
- (IBAction)msgYaoQingButton:(id)sender;
- (IBAction)weiXinYaoQingButton:(id)sender;
- (IBAction)hideCurView:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)hideInvitationView:(id)sender;
- (IBAction)changeAvator:(UIButton *)sender;
@end
