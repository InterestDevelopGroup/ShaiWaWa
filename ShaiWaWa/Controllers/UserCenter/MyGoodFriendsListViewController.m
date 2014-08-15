//
//  MyGoodFriendsListViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MyGoodFriendsListViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "MyGoodFriendsListCell.h"
#import "FriendHomeViewController.h"
#import "MyGoodFriendsListViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
@interface MyGoodFriendsListViewController ()
{
    NSMutableArray *friendList;
}
@end

@implementation MyGoodFriendsListViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Methods
- (void)initUI
{
    
    
    self.title = @"我的好友";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    friendList = [[NSMutableArray alloc] init];
    UIImage *img = [[UIImage imageNamed:@"main_2-bg2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    _goodFriendListTableView.backgroundView = imgView;
    [_goodFriendListTableView registerNibWithName:@"MyGoodFriendsListCell" reuseIdentifier:@"Cell"];
    if ([friendList count]*80 < _goodFriendListTableView.bounds.size.height) {
        _goodFriendListTableView.frame = CGRectMake(20, 60, 285,[friendList count]*80);
    }
    NSLog(@"%@",@{@"uid":user.uid,@"offset":@"0", @"pagesize": @"10"});
    [[HttpService sharedInstance] getFriendList:@{@"uid":user.uid,@"offset":@"0", @"pagesize": @"10"} completionBlock:^(id object) {
        
        if (![[object objectForKey:@"result"] isEqual:[NSNull null]]) {
              friendList = [object objectForKey:@"result"];
              [_goodFriendListTableView reloadData];
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
}

#pragma mark - UITableView DataSources and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [friendList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    MyGoodFriendsListCell *cell = (MyGoodFriendsListCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    
//    cell.headPicView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_mama.png"]];
//    cell.nickNameLabel.text = @"张氏";
//    cell.countOfBabyLabel.text = @"1个宝宝";
//    cell.remarksLabel.text = @"孩子他妈";
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendHomeViewController *friendHomeVC = [[FriendHomeViewController alloc] init];
    friendHomeVC.friendId = [[friendList objectAtIndex:indexPath.row] objectForKey:@"id"];
    [self.navigationController pushViewController:friendHomeVC animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    [textField resignFirstResponder];
    [[HttpService sharedInstance] searchFriend:@{@"uid":users.uid,
                                                 @"keyword":_keyworkField.text,
                                                 @"offset":@"0",
                                                 @"pagesize":@"10"} completionBlock:^(id object) {
                                                     if (![[object objectForKey:@"result"] isEqual:[NSNull null]]) {
                                                         friendList = [object objectForKey:@"result"];
                                                         if ([friendList count]*80 < _goodFriendListTableView.bounds.size.height) {
                                                             _goodFriendListTableView.frame = CGRectMake(20, 60, 285,[friendList count]*80);
                                                         }
                                                         [_goodFriendListTableView reloadData];
                                                     }
                                                 } failureBlock:^(NSError *error, NSString *responseString) {
                                                     NSString * msg = responseString;
                                                     if (error) {
                                                         msg = @"加载失败";
                                                     }
                                                     [SVProgressHUD showErrorWithStatus:msg];
                                                 }];
    return YES;
}
@end
