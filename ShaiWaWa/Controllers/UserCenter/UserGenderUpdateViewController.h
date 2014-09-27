//
//  UserGenderUpdateViewController.h
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "CommonViewController.h"

@interface UserGenderUpdateViewController : CommonViewController
{
    BOOL isSecure,isMan,isWoman;
}
@property (strong, nonatomic) IBOutlet UIButton *secureButton;
@property (strong, nonatomic) IBOutlet UIButton *manButton;
@property (strong, nonatomic) IBOutlet UIButton *womanButton;
- (IBAction)secureSelected:(id)sender;
- (IBAction)manSelected:(id)sender;
- (IBAction)womanSelected:(id)sender;

- (IBAction)update_ok:(id)sender;

@end
