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
#import <ShareSDK/ShareSDK.h>
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
            [self bindSina];
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
            [self bindQQ];
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

- (void)bindQQ
{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         
         if(error)
         {
//             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"授权失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//             [alertView show];
//             alertView = nil;
             
             [SVProgressHUD showErrorWithStatus:@"授权失败"];
             return ;
         }
         
         if(!result)
         {
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"登陆失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alertView show];
             alertView = nil;
             [SVProgressHUD dismiss];
             return ;
             
         }
         
         NSLog(@"获取用户所属平台类型:%d",[userInfo type]);
         NSLog(@"获取用户个人主页:%@",[userInfo url]);
         NSLog(@"获取用户认证类型:%d",[userInfo verifyType]);
         NSLog(@"获取用户职业信息:%@",[userInfo works]);
         NSLog(@"获取用户id:%@",[userInfo uid]);
         NSLog(@"获取用户昵称:%@",[userInfo nickname]);
         NSLog(@"获取用户个人简介:%@",[userInfo aboutMe]);
         NSLog(@"获取用户所属的应用:%@",[userInfo app]);
         NSLog(@"获取用户的原始数据信息:%@",[userInfo sourceData]);
         NSLog(@"获取用户分享数:%d",[userInfo shareCount]);
         NSLog(@"获取用户注册时间:%f",[userInfo regAt]);
         NSLog(@"获取用户个人头像:%@",[userInfo profileImage]);
         NSLog(@"获取用户等级%d",[userInfo level]);
         NSLog(@"获取用户性别:%d",[userInfo gender]);
         NSLog(@"获取用户关注数:%d",[userInfo friendCount]);
         NSLog(@"获取用户粉丝数:%d",[userInfo followerCount]);
         NSLog(@"获取用户的教育信息列表:%@",[userInfo educations]);
         NSLog(@"获取用户生日:%@",[userInfo birthday]);
         NSLog(@"token:%@",[[userInfo credential] token]);
         NSLog(@"secret:%@",[[userInfo credential] secret]);
         
         NSString * key = @"QQ_ACCESS_TOKEN";
         NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
         [userDefault setObject:[[userInfo credential] token] forKey:key];
         [userDefault synchronize];
         
         [self bindWithType:@"1" userInfo:userInfo];

     }];

}

- (void)bindSina
{
//    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error)
     {
         if(error)
         {
             NSLog(@"%@",error);
//             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"授权失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//             [alertView show];
//             alertView = nil;
             [SVProgressHUD showErrorWithStatus:@"授权失败"];
             return  ;
         }
         
         if(!result)
         {
             UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"登陆失败." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
             [alertView show];
             alertView = nil;
             [SVProgressHUD dismiss];
             return ;
             
         }
         
         NSLog(@"获取用户所属平台类型:%d",[userInfo type]);
         NSLog(@"获取用户个人主页:%@",[userInfo url]);
         NSLog(@"获取用户认证类型:%d",[userInfo verifyType]);
         NSLog(@"获取用户职业信息:%@",[userInfo works]);
         NSLog(@"获取用户id:%@",[userInfo uid]);
         NSLog(@"获取用户昵称:%@",[userInfo nickname]);
         NSLog(@"获取用户个人简介:%@",[userInfo aboutMe]);
         NSLog(@"获取用户所属的应用:%@",[userInfo app]);
         NSLog(@"获取用户的原始数据信息:%@",[userInfo sourceData]);
         NSLog(@"获取用户分享数:%d",[userInfo shareCount]);
         NSLog(@"获取用户注册时间:%f",[userInfo regAt]);
         NSLog(@"获取用户个人头像:%@",[userInfo profileImage]);
         NSLog(@"获取用户等级%d",[userInfo level]);
         NSLog(@"获取用户性别:%d",[userInfo gender]);
         NSLog(@"获取用户关注数:%d",[userInfo friendCount]);
         NSLog(@"获取用户粉丝数:%d",[userInfo followerCount]);
         NSLog(@"获取用户的教育信息列表:%@",[userInfo educations]);
         NSLog(@"获取用户生日:%@",[userInfo birthday]);
         NSLog(@"token:%@",[[userInfo credential] token]);
         NSLog(@"secret:%@",[[userInfo credential] secret]);
         
         NSString * key = @"SIAN_ACCESS_TOKEN";
         NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
         [userDefault setObject:[[userInfo credential] token] forKey:key];
         [userDefault synchronize];
         
         [self bindWithType:@"2" userInfo:userInfo];
     }];

}


- (void)bindWithType:(NSString *)type userInfo:(id<ISSPlatformUser>)userInfo
{
    if([type isEqualToString:@"1"])
    {
        [[HttpService sharedInstance] get:@"https://graph.qq.com/oauth2.0/me" parameters:@{@"access_token":[[userInfo credential] token]} completionBlock:^(id obj) {
            
            //不需要处理成功返回的数据，因为服务端返回的数据不是json根式
        } failureBlock:^(NSError *error, NSString *responseString) {
            
            NSRange range1 = [responseString rangeOfString:@"{"];
            NSRange range2 = [responseString rangeOfString:@"}"];
            
            NSString * jsonStr = [responseString substringWithRange:NSMakeRange(range1.location, range2.location + 1 - range1.location)];
            NSDictionary * info = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
            //没有出错
            if(info[@"openid"] != nil)
            {
                [self loginWithOpenID:info[@"openid"] withType:@"1"];
                return ;
            }
            
            //错误提示
            NSString * msg = responseString;
            if(error)
            {
                msg = @"绑定失败.";
            }
            [SVProgressHUD showErrorWithStatus:msg];
        }];

    }
    else
    {
        [self loginWithOpenID:[userInfo uid] withType:@"2"];
    }
}


- (void)loginWithOpenID:(NSString *)openID withType:(NSString *)type
{

    NSMutableDictionary * params = [@{} mutableCopy];
    params[@"uid"] = users.uid;
    params[@"open_id"] = openID;
    params[@"type"] = type;
    [[HttpService sharedInstance] bindOpenLogin:params completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"绑定成功."];
        
        if([type isEqualToString:@"1"])
        {
            users.tecent_openId = openID;
        }
        else if([type isEqualToString:@"2"])
        {
            users.sina_openId = openID;
        }
        
        [[UserDefault sharedInstance] setUserInfo:users];
        
        [_platformListTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        //错误提示
        NSString * msg = responseString;
        if(error)
        {
            msg = @"绑定失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
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
            cell.platformNameLabel.text = [NSString stringWithFormat:@"新浪微博(%@)",users.username];

            if(users.sina_openId == nil)
            {
                cell.platformNameLabel.text = @"新浪微博";
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
            cell.platformNameLabel.text = [NSString stringWithFormat:@"QQ(%@)",users.username];
            if (users.tecent_openId == nil) {
                
                //cell.platformCurBindButton.hidden = NO;
                cell.platformNameLabel.text = @"QQ";
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
            cell.platformNameLabel.text = [NSString stringWithFormat:@"手机(%@)",users.phone];
            if (users.phone == nil)
            {
               //cell.platformCurBindButton.hidden = NO;
                cell.platformNameLabel.text = @"手机";
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
