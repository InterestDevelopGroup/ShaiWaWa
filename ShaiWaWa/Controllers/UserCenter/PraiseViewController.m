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
    cell.remarksLabel.hidden = YES;
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OtherInformationViewController *otherUserInfoVC = [[OtherInformationViewController alloc] init];
    [self.navigationController pushViewController:otherUserInfoVC animated:YES];
}
@end
