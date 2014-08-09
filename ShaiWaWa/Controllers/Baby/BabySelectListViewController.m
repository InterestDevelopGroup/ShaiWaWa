//
//  BabySelectListViewController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-9.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BabySelectListViewController.h"
#import "UIViewController+BarItemAdapt.h"

#import "BabyListCell.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
@interface BabySelectListViewController ()
{
    NSMutableArray *myBabyListArray;
}
@end

@implementation BabySelectListViewController

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
    myBabyListArray = [[NSMutableArray alloc] init];
    [_myBabyList clearSeperateLine];
    [_myBabyList registerNibWithName:@"BabyListCell" reuseIdentifier:@"Cell"];
    
    
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    NSLog(@"%@",@{@"offset":@"0",
                  @"pagesize":@"10",
                  @"uid":user.uid});
    
    
    [[HttpService sharedInstance] getBabyList:@{@"offset":@"0",
                                                @"pagesize":@"10",
                                                @"uid":user.uid}
                              completionBlock:^(id object) {
                                  myBabyListArray = [object objectForKey:@"result"];
                                  [_myBabyList reloadData];
                              } failureBlock:^(NSError *error, NSString *responseString) {
                                  [SVProgressHUD showErrorWithStatus:responseString];
                              }];
}


#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myBabyListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BabyListCell * babyListCell = (BabyListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    babyListCell.babyNameLabel.text = [NSString stringWithFormat:@"%@",[[myBabyListArray objectAtIndex:indexPath.row] objectForKey:@"baby_name"]];
    
    return babyListCell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _babyAvatarBlock([[myBabyListArray objectAtIndex:indexPath.row] objectForKey:@"avatar"]);
    _babyIdBlock([[myBabyListArray objectAtIndex:indexPath.row] objectForKey:@"baby_id"]);
    _babyNameBlock([[myBabyListArray objectAtIndex:indexPath.row] objectForKey:@"baby_name"]);
    [self.navigationController popViewControllerAnimated:YES];
}
@end
