//
//  FriendHomeViewController.h
//  ShaiWaWa
//
//  Created by 祥 on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface FriendHomeViewController : CommonViewController
{
    BOOL isDelBtnShown;
    UIButton *delBtn;
}
@property (strong, nonatomic) IBOutlet UIButton *babyButton;
@property (strong, nonatomic) IBOutlet UIButton *dynamicButton;
@property (strong, nonatomic) IBOutlet UIButton *goodFriendButton;
@end
