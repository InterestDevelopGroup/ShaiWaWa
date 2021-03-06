//
//  FriendHomeViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface FriendHomeViewController : CommonViewController
{
    BOOL isDelBtnShown;
    UIButton *delBtn;
    UIBarButtonItem * addItem;
    UIBarButtonItem *right_doWith;
}
@property (strong, nonatomic) IBOutlet UIButton *babyButton;
@property (strong, nonatomic) IBOutlet UIButton *dynamicButton;
@property (strong, nonatomic) IBOutlet UIButton *goodFriendButton;
@property (weak, nonatomic) IBOutlet UIImageView *friendAvatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *friendUserNameTextField;
@property (weak, nonatomic) IBOutlet UILabel *friendSwwNumTextField;
@property (strong, nonatomic) NSString *friendId;
@end
