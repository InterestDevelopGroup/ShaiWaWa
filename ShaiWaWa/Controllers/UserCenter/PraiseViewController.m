//
//  PraiseViewController.m
//  ShaiWaWa
//
//  Created by x on 14-7-13.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PraiseViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "MyGoodFriendsListCell.h"
#import "OtherInformationViewController.h"
#import "FriendHomeViewController.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"
@interface PraiseViewController ()

@end

@implementation PraiseViewController
@synthesize priaseRid;
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
    praisePersonArr = [[NSMutableArray alloc] init];
    self.title = [NSString stringWithFormat:@"%i人觉得很赞",[praisePersonArr count]];
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_praisePersonListTableView registerNibWithName:@"MyGoodFriendsListCell" reuseIdentifier:@"Cell"];
    [_praisePersonListTableView clearSeperateLine];
    [[HttpService sharedInstance] getLikingList:@{@"rid":priaseRid} completionBlock:^(id object) {
        praisePersonArr = [object objectForKey:@"result"];
        if (![praisePersonArr isEqual:[NSNull null]]) {
            self.title = [NSString stringWithFormat:@"%i人觉得很赞",[praisePersonArr count]];
        }
        [_praisePersonListTableView reloadData];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    
    
    
}

#pragma mark - UITableView DataSources and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([praisePersonArr isEqual:[NSNull null]]) {
        return 0;
    }
    else
    {
        return [praisePersonArr count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    MyGoodFriendsListCell *cell = (MyGoodFriendsListCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    
    [[HttpService sharedInstance] getUserInfo:@{@"uid":[[praisePersonArr objectAtIndex:indexPath.row] objectForKey:@"uid"]} completionBlock:^(id obj) {
        cell.nickNameLabel.text = [[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"username"];
        cell.headPicView.image = [UIImage imageWithContentsOfFile:[[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"avatar"]];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
    [[HttpService sharedInstance] getBabyList:@{@"offset":@"0",
                                                @"pagesize":@"10",
                                                @"uid":[[praisePersonArr objectAtIndex:indexPath.row] objectForKey:@"uid"]} completionBlock:^(id obj) {
                                                    
                                                    cell.countOfBabyLabel.text = [NSString stringWithFormat:@"%i个宝宝",[[obj objectForKey:@"result"] count]];
                                                } failureBlock:^(NSError *error, NSString *responseString) {
                                                    NSString * msg = responseString;
                                                    if (error) {
                                                        msg = @"加载失败";
                                                    }
                                                    [SVProgressHUD showErrorWithStatus:msg];
                                                }];
    
    cell.remarksLabel.hidden = YES;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getFriendList:@{@"uid":users.uid,@"offset":@"0", @"pagesize": @"10"} completionBlock:^(id object) {
        
        if (![[object objectForKey:@"result"] isEqual:[NSNull null]]) {
           NSMutableArray *friendList = [object objectForKey:@"result"];
            if ([friendList containsObject:[[praisePersonArr objectAtIndex:indexPath.row] objectForKey:@"uid"]]) {
                FriendHomeViewController *friendHomeVC = [[FriendHomeViewController alloc] init];
                friendHomeVC.friendId = [[praisePersonArr objectAtIndex:indexPath.row] objectForKey:@"uid"];
                [self.navigationController pushViewController:friendHomeVC animated:YES];
            }
            else
            {
                OtherInformationViewController *otherUserInfoVC = [[OtherInformationViewController alloc] init];
                otherUserInfoVC.otherId = [[praisePersonArr objectAtIndex:indexPath.row] objectForKey:@"uid"];
                [self.navigationController pushViewController:otherUserInfoVC animated:YES];
            }
            
        }
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
    
}
@end
