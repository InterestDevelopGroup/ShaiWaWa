//
//  SummaryCell.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SummaryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *summaryKeyLabel;
@property (weak, nonatomic) IBOutlet UITextField *summaryValueField;

@property (weak, nonatomic) IBOutlet UIImageView *sexImgView;
@end
