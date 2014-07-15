//
//  MessageViewController.h
//  ShaiWaWa
//
//  Created by x on 14-7-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"
#import "HMSegmentedControl.h"

@interface MessageViewController : CommonViewController<UIScrollViewDelegate>
{
    HMSegmentedControl *segMentedControl;
//    BOOL isRightBtnSelected;
}
@property (strong, nonatomic) IBOutlet UIView *tabSelectionBar;

@property (strong, nonatomic) IBOutlet UIScrollView *segScrollView;
@end
