//
//  DynamicCell.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *praiseUserThirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseUserSecondBtn;
@property (weak, nonatomic) IBOutlet UIButton *praiseUserFirstBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UILabel *topicView;
@property (weak, nonatomic) IBOutlet UIView *likeUserView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *whoLabel;
@property (weak, nonatomic) IBOutlet UILabel *releaseTimeLabel;
@property (weak, nonatomic) IBOutlet UITextView *dyContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *babyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *babyBirthdayLabel;

@property (weak, nonatomic) IBOutlet UIButton *zanButton;
@property (weak, nonatomic) IBOutlet UIImageView *babyAvatarImageView;

@end
