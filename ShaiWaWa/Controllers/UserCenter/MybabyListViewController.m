//
//  MybabyViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MybabyListViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "BabyListCell.h"
#import "BabyHomePageViewController.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"

@interface MybabyListViewController ()
{
    NSMutableArray *myBabyList;
}
@end

@implementation MybabyListViewController

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
    self.title = @"我的宝宝";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_babyListTableView clearSeperateLine];
    [_babyListTableView registerNibWithName:@"BabyListCell" reuseIdentifier:@"Cell"];
    
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    NSLog(@"%@",@{@"offset":@"0",
                  @"pagesize":@"10",
                  @"uid":user.uid});
    
    
    [[HttpService sharedInstance] getBabyList:@{@"offset":@"0",
                                                @"pagesize":@"10",
                                                @"uid":user.uid}
                              completionBlock:^(id object) {
                                  
                                  myBabyList = [object objectForKey:@"result"];
                                  [_babyListTableView reloadData];
                                  [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                              } failureBlock:^(NSError *error, NSString *responseString) {
                                  [SVProgressHUD showErrorWithStatus:responseString];
                              }];
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myBabyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BabyListCell * babyListCell = (BabyListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    babyListCell.babyNameLabel.text = [NSString stringWithFormat:@"%@",[[myBabyList objectAtIndex:indexPath.row] objectForKey:@"baby_name"]];
    babyListCell.babyOldLabel.text = [NSString stringWithFormat:@"%@",[[myBabyList objectAtIndex:indexPath.row] objectForKey:@"birthday"]];
    if ([[[myBabyList objectAtIndex:indexPath.row] objectForKey:@"sex"] intValue] == 0) {
        babyListCell.babySexImage.image = [UIImage imageNamed:@"main_girl.png"];
    }
    else
    {
        babyListCell.babySexImage.image = [UIImage imageNamed:@"main_boy.png"];
    }
    
    
    //babyListCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    babyListCell.babyImage.image = [UIImage imageNamed:@""];
    
    return babyListCell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_babyListTableView deselectRowAtIndexPath:indexPath animated:YES];
    BabyHomePageViewController *babyHomePageVC = [[BabyHomePageViewController alloc] initWithNibName:nil bundle:nil];
    babyHomePageVC.curBaby_id = [[myBabyList objectAtIndex:indexPath.row] objectForKey:@"baby_id"];
    [self.navigationController pushViewController:babyHomePageVC animated:YES];
    
}
@end
