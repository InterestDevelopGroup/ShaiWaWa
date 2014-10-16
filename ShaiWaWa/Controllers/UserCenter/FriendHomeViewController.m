//
//  FriendHomeViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-6.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "FriendHomeViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "UIImageView+WebCache.h"
#import "DynamicByUserIDViewController.h"
#import "MybabyListViewController.h"
#import "HisFriendsViewController.h"
#import "AddFriendViewController.h"
@interface FriendHomeViewController ()<UIAlertViewDelegate>
{
    NSMutableArray *babyList;
    UserInfo * user;
}

@end

@implementation FriendHomeViewController
@synthesize friendId;
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
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView)]];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //返回时让删除按钮消失
    [self tapView];
}

#pragma mark - Private Methods
- (void)initUI
{
    isDelBtnShown = NO;
    [self setLeftCusBarItem:@"square_back" action:nil];
    if ([OSHelper iOS7])
    {
        right_doWith = [self customBarItem:@"user_gengduo" action:@selector(showDelButton) size:CGSizeMake(38, 30) imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -25)];
        
    }
    else
    {
        right_doWith = [self customBarItem:@"user_gengduo" action:@selector(showDelButton)];
    }
    
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, 70, 33);
    addBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [addBtn setTitle:@"加为好友" forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
    addItem = [[UIBarButtonItem alloc] initWithCustomView:addBtn];
    delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setImage:[UIImage imageNamed:@"user_shanchu"] forState:UIControlStateNormal];
    delBtn.frame = CGRectMake(self.navigationController.navigationBar.bounds.size.width-90, self.navigationController.navigationBar.bounds.size.height+10, 84, 41);
    [delBtn addTarget:self action:@selector(deleteFriend) forControlEvents:UIControlEventTouchUpInside];
    
    [self getUserInfo];
    
}


- (void)getUserInfo
{
    if (friendId == nil) {
        [SVProgressHUD showErrorWithStatus:@"该用户不存在！"];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeGradient];
    
    [[HttpService sharedInstance] getUserInfo:@{@"uid":friendId} completionBlock:^(id object) {
        
        user = (UserInfo *)object;
        if (user == nil) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"该用户不存在", nil)];
            [self.navigationController popVIewController];
            return ;
        }
        [_friendAvatarImgView sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"user_touxiang"]];
        _friendUserNameTextField.text = user.username;
        _friendSwwNumTextField.text = user.sww_number;
        self.title = user.username;
        [self babyCell];
        [self dynamicCell];
        [self goodFriendCell];
        
        [SVProgressHUD showSuccessWithStatus:@"加载成功"];
        //判断用户是否为好友
        [self isFriends];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}


- (void)isFriends
{
    
    UserInfo * userInfo = [[UserDefault sharedInstance] userInfo];
    
    [[HttpService sharedInstance] isFriend:@{@"uid":userInfo.uid,@"friend_id":friendId} completionBlock:^(id object) {
        
        if([object intValue] == Not_Friend_Error_Code)
        {
            self.navigationItem.rightBarButtonItem = addItem;
        }
        else if([object intValue] == Normal_Friend_Error_Code)
        {
            self.navigationItem.rightBarButtonItem = right_doWith;
        }
        else if([object intValue] == Is_Spouses_Error_Code)
        {
            self.navigationItem.rightBarButtonItem = nil;
        }
        
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
 
    }];
}

- (void)addAction:(id)sender
{
    /*
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"请输入备注" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"提交", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
    */
    AddFriendViewController * vc = [[AddFriendViewController alloc] initWithNibName:nil bundle:nil];
    vc.friendID = user.uid;
    [self push:vc];
    vc = nil;
}

- (void)babyCell
{
    UILabel *babyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _babyButton.bounds.size.height-10)];
    babyLabel.backgroundColor = [UIColor clearColor];
    babyLabel.font = [UIFont systemFontOfSize:15];
    babyLabel.textColor = [UIColor darkGrayColor];
    babyLabel.text = [NSString stringWithFormat:@"宝宝 (%@)",user.baby_count];
    [_babyButton addSubview:babyLabel];
    [_babyButton addTarget:self action:@selector(showHisBabys) forControlEvents:UIControlEventTouchUpInside];
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_babyButton.bounds.size.width-18, 15, 7, 11);
    [_babyButton addSubview:jianTou];
}

- (void)dynamicCell
{
    UILabel *dynamicLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _dynamicButton.bounds.size.height-10)];
    dynamicLabel.backgroundColor = [UIColor clearColor];
    dynamicLabel.font = [UIFont systemFontOfSize:15];
    dynamicLabel.text = [NSString stringWithFormat:@"动态 (%@)",user.record_count];
    dynamicLabel.textColor = [UIColor darkGrayColor];
    [_dynamicButton addSubview:dynamicLabel];
    [_dynamicButton addTarget:self action:@selector(showHisDynamic) forControlEvents:UIControlEventTouchUpInside];
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_dynamicButton.bounds.size.width-18, 15, 7, 11);
    [_dynamicButton addSubview:jianTou];
}

- (void)goodFriendCell
{
    UILabel *goodFriendLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 120, _goodFriendButton.bounds.size.height-10)];
    goodFriendLabel.backgroundColor = [UIColor clearColor];
    goodFriendLabel.text = [NSString stringWithFormat:@"好友 (%@)",user.friend_count];
    goodFriendLabel.font = [UIFont systemFontOfSize:15];
    goodFriendLabel.textColor = [UIColor darkGrayColor];
    [_goodFriendButton addSubview:goodFriendLabel];
    [_goodFriendButton addTarget:self action:@selector(showHisFriend) forControlEvents:UIControlEventTouchUpInside];
    UIImage *imageJianTou = [UIImage imageNamed:@"main_jiantou.png"];
    UIImageView *jianTou = [[UIImageView alloc] initWithImage:imageJianTou];
    jianTou.frame = CGRectMake(_goodFriendButton.bounds.size.width-18, 15, 7, 11);
    [_goodFriendButton addSubview:jianTou];
}

- (void)showHisBabys
{
    if([user.baby_count isEqualToString:@"0"])
    {
        return ;
    }
    
    MybabyListViewController * vc = [[MybabyListViewController alloc] initWithNibName:nil bundle:nil];
    vc.user = user;
    [self push:vc];
    vc = nil;
}

- (void)showHisDynamic
{
    if([user.record_count isEqualToString:@"0"])
    {
        return ;
    }
    
    DynamicByUserIDViewController * vc = [[DynamicByUserIDViewController alloc] initWithNibName:nil bundle:nil];
    vc.user = user;
    [self push:vc];
    vc = nil;
}

- (void)showHisFriend
{
    if([user.friend_count isEqualToString:@"0"])
    {
        return ;
    }
    
    HisFriendsViewController * vc = [[HisFriendsViewController alloc] initWithNibName:nil bundle:nil];
    vc.user = user;
    [self push:vc];
    vc = nil;
}

#pragma 删除按钮
- (void)showDelButton
{
    if (!isDelBtnShown)
    {
        [self.navigationController.view addSubview:delBtn];
        isDelBtnShown = YES;
    }
    else
    {
        [delBtn removeFromSuperview];
        isDelBtnShown = NO;
    }
}
#pragma mark - 删除好友按钮
- (void)deleteFriend
{
    UserInfo * users = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] deleteFriend:@{@"uid":users.uid,@"friend_id":friendId} completionBlock:^(id object) {
        self.navigationItem.rightBarButtonItem = addItem;
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"删除好友失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark -点击屏幕，让删除按钮消失
- (void)tapView
{
    if (delBtn.superview != nil)
    {
        [delBtn removeFromSuperview];
        isDelBtnShown = NO;
    }
}

#pragma mark - 返回按钮
- (void)back
{
    [self tapView];
}


#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == alertView.cancelButtonIndex)
    {
        return ;
    }
    
    UITextField * textField = [alertView textFieldAtIndex:0];
    NSString * remark = textField.text == nil ? @"" : textField.text;
    
    UserInfo * userInfo = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] applyFriend:@{@"uid":userInfo.uid,@"friend_id":user.uid,@"remark":remark} completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:@"已提交申请"];
        self.navigationItem.rightBarButtonItem = nil;
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"申请好友失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
        
    }];

}

@end
