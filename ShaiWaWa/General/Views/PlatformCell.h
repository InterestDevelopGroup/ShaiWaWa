//
//  PlatformCell.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlatformCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *platformIconView;
@property (strong, nonatomic) IBOutlet UILabel *platformNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *platformCurBindButton;

@end
