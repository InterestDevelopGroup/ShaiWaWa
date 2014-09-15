//
//  QRCodeCardViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "QRCodeCardViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "UIImageView+WebCache.h"
#import "QRCodeGenerator.h"
@interface QRCodeCardViewController ()

@end

@implementation QRCodeCardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"二维码名片";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UserInfo * user = [[UserDefault sharedInstance] userInfo];
    _usernameLabel.text = user.username;
    [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:_avatarImageView.image];
    _qrCodeImageView.image = [QRCodeGenerator qrImageForString:[NSString stringWithFormat:@"#com.gzinterest.%@#",user.uid] imageSize:CGRectGetWidth(_qrCodeImageView.frame)];
}
@end
