//
//  AddrBookCell.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddrBookCell : UITableViewCell
@property (assign) BOOL isAddBtn_Selected;
@property (weak, nonatomic) IBOutlet UIImageView *touXiangImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *addFriendButton;

@end
