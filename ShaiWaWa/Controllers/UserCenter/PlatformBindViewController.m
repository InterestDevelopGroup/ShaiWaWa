//
//  PlatformBindViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PlatformBindViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "PlatformCell.h"
#import "UserDefault.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "SearchAddressBookViewController.h"
#import "SetPasswordStepOneViewController.h"
#import "HttpService.h"
@interface PlatformBindViewController ()
{
    UserInfo *users;
}
@end

@implementation PlatformBindViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    users = [[UserDefault sharedInstance] userInfo];
    [_platformListTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"社交平台绑定";
    [self setLeftCusBarItem:@"square_back" action:nil];
    
    users = [[UserDefault sharedInstance] userInfo];
    
    UIImage *img = [[UIImage imageNamed:@"main_2-bg2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    _platformListTableView.backgroundView = imgView;
    [_platformListTableView registerNibWithName:@"PlatformCell" reuseIdentifier:@"Cell"];
    [_platformListTableView clearSeperateLine];
    if (3*80 < _platformListTableView.bounds.size.height) {
        _platformListTableView.frame = CGRectMake(11, 10, 299,3*40);
    }
}

- (void)bindAction:(UIButton *)sender
{
    PlatformCell * cell;
    if([sender.superview.superview.superview isKindOfClass:[PlatformCell class]])
    {
        cell = (PlatformCell *)sender.superview.superview.superview;
    }
    else if([sender.superview.superview isKindOfClass:[PlatformCell class]])
    {
        cell = (PlatformCell *)sender.superview.superview;
    }
    else
    {
        cell = (PlatformCell *)sender.superview;
    }
    
    NSIndexPath * indexPath = [_platformListTableView indexPathForCell:cell];
    if(indexPath.row == 0)
    {
        if(users.sina_openId == nil)
        {
            //绑定微博
            [SVProgressHUD showErrorWithStatus:@"申请中..."];
        }
        else
        {
            //解除微博绑定
            if(users.tecent_openId == nil && users.phone)
            {
                [SVProgressHUD showErrorWithStatus:@"至少要有一个平台绑定"];
                return ;
            }
            
            [self unbindWithType:@"3"];
        }
    }
    else if(indexPath.row == 1)
    {
        if(users.tecent_openId == nil)
        {
            //绑定腾讯
            [SVProgressHUD showErrorWithStatus:@"申请中..."];
        }
        else
        {
            //解除绑定腾讯
            if(users.sina_openId == nil && users.phone == nil)
            {
                [SVProgressHUD showErrorWithStatus:@"至少要有一个平台绑定"];
                return ;
            }
            
            [self unbindWithType:@"2"];
        }
    }
    else if(indexPath.row == 2)
    {
        
        if(users.phone == nil)
        {
            //绑定手机
            SearchAddressBookViewController * vc = [[SearchAddressBookViewController alloc] initWithNibName:nil bundle:nil];
            vc.type = @"1";
            [self push:vc];
            vc = nil;
        }
        else
        {
            //解除绑定
            if(users.tecent_openId == nil && users.sina_openId == nil)
            {
                [SVProgressHUD showErrorWithStatus:@"至少要有一个平台绑定"];
                return ;
            }
            [self unbindWithType:@"1"];
        }
    }
    
}

- (IBAction)setPassword:(id)sender
{
    if(users.phone == nil)
    {
        [SVProgressHUD showErrorWithStatus:@"请先绑定手机."];
        return ;
    }
    
    SetPasswordStepOneViewController * vc = [[SetPasswordStepOneViewController alloc] initWithNibName:nil bundle:nil];
    [self push:vc];
    vc = nil;
    
}

- (void)unbindWithType:(NSString *)type
{
    if(type == nil)
    {
        return ;
    }
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [[HttpService sharedInstance] unbind:@{@"uid":users.uid,@"type":type} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"操作成功."];
        
        if([type isEqualToString:@"1"])
        {
            users.phone = nil;
        }
        else if([type isEqualToString:@"2"])
        {
            users.tecent_openId = nil;
        }
        else if([type isEqualToString:@"3"])
        {
            users.sina_openId = nil;
        }
        
        [[UserDefault sharedInstance] setUserInfo:users];
        
        [_platformListTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"操作失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


#pragma mark - UITableView DataSources and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    PlatformCell *cell = (PlatformCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    [cell.platformCurBindButton addTarget:self action:@selector(bindAction:) forControlEvents:UIControlEventTouchUpInside];
    switch (indexPath.row) {
        case 0:
            cell.platformIconView.image = [UIImage imageNamed:@"user_3-weibo"];
            cell.platformNameLabel.text = @"微博";

            if(users.sina_openId == nil)
            {
                //cell.platformCurBindButton.hidden = NO;
                [cell.platformCurBindButton setImage:[UIImage imageNamed:@"bangding.png"] forState:UIControlStateNormal];
            }
            else
            {
                //cell.platformCurBindButton.hidden = YES;
                [cell.platformCurBindButton setImage:[UIImage imageNamed:@"jiebaoding.png"] forState:UIControlStateNormal];
            }
            
            break;
        case 1:
            cell.platformIconView.image = [UIImage imageNamed:@"qq"];
            cell.platformNameLabel.text = @"QQ";
            if (users.tecent_openId == nil) {
                
                //cell.platformCurBindButton.hidden = NO;
                [cell.platformCurBindButton setImage:[UIImage imageNamed:@"bangding.png"] forState:UIControlStateNormal];
            }
            else
            {
                //cell.platformCurBindButton.hidden = YES;
                [cell.platformCurBindButton setImage:[UIImage imageNamed:@"jiebaoding.png"] forState:UIControlStateNormal];
            }
            break;
        case 2:
            cell.platformIconView.image = [UIImage imageNamed:@"dianhua2"];
            cell.platformNameLabel.text = @"手机";
            if (users.phone == nil)
            {
               //cell.platformCurBindButton.hidden = NO;
               [cell.platformCurBindButton setImage:[UIImage imageNamed:@"bangding.png"] forState:UIControlStateNormal];
            }
            else
            {
                //cell.platformCurBindButton.hidden = YES;
                [cell.platformCurBindButton setImage:[UIImage imageNamed:@"jiebaoding.png"] forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
@end
