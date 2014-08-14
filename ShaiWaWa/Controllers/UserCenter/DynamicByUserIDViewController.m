//
//  DynamicByUserIDViewController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-14.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "DynamicByUserIDViewController.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "UIViewController+BarItemAdapt.h"
#import "DynamicCell.h"
#import "DynamicDetailViewController.h"
@interface DynamicByUserIDViewController ()
{
    NSMutableArray *dyArray;
}
@end

@implementation DynamicByUserIDViewController

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

- (void)initUI
{
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    self.title = @"动态";
    [self setLeftCusBarItem:@"square_back" action:nil];
    dyArray = [[NSMutableArray alloc] init];
    [_dyTableView clearSeperateLine];
    [_dyTableView registerNibWithName:@"DynamicCell" reuseIdentifier:@"Cell"];
    
    [[HttpService sharedInstance] getRecordList:@{@"offset":@"0", @"pagesize":@"10",@"uid":users.uid} completionBlock:^(id object) {
        dyArray = [object objectForKey:@"result"];
        [_dyTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if (error) {
            msg = @"加载失败";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![dyArray isEqual:[NSNull null]]) {
        return [dyArray count];
    }
    else
    {
        return 0;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (![[[dyArray objectAtIndex:indexPath.row] objectForKey:@"add_time"] isEqual:[NSNull null]]) {
        dynamicCell.releaseTimeLabel.text = [[dyArray objectAtIndex:indexPath.row] objectForKey:@"add_time"];
    }
    if (![[[dyArray objectAtIndex:indexPath.row] objectForKey:@"address"] isEqual:[NSNull null]]) {
        dynamicCell.addressLabel.text = [[dyArray objectAtIndex:indexPath.row] objectForKey:@"address"];
    }
    if (![[[dyArray objectAtIndex:indexPath.row] objectForKey:@"content"] isEqual:[NSNull null]]) {
        dynamicCell.dyContentTextView.text = [[dyArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    }
    
    dynamicCell.moreBtn.tag = indexPath.row + 2222;
    dynamicCell.zanButton.tag = indexPath.row + 555;
    [dynamicCell.zanButton setTitle:@"1" forState:UIControlStateNormal];
    return dynamicCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] init];
    dynamicDetailVC.r_id = [[dyArray objectAtIndex:indexPath.row] objectForKey:@"rid"];
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}

@end
