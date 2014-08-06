//
//  BabyListViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "BabyListViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "BabyListCell.h"
#import "BabyHomePageViewController.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"

@interface BabyListViewController ()

@end

@implementation BabyListViewController

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
    self.title = @"宝宝列表";
    [self setLeftCusBarItem:@"square_back" action:nil];
    sectionArr = [[NSArray alloc] initWithObjects:@"我的宝宝",@"好友的宝宝", nil];
    myBabyList = [[NSArray alloc] init];
    friendsBabyList =  [[NSArray alloc] init];
    babyAll = [NSArray arrayWithObjects:myBabyList,friendsBabyList, nil];
    //以段名数组，段数据为参数创建数据资源用的字典实例
    babyList = [[NSDictionary alloc] initWithObjects:babyAll forKeys:sectionArr];
    
    //[_babyListTableView clearSeperateLine];
    //[_babyListTableView registerNibWithName:@"BabyListCell" reuseIdentifier:@"Cell"];
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
                                  babyAll = [NSArray arrayWithObjects:myBabyList,friendsBabyList, nil];
                                  //以段名数组，段数据为参数创建数据资源用的字典实例
                                  babyList = [[NSDictionary alloc] initWithObjects:babyAll forKeys:sectionArr];
                                  [_babyListTableView reloadData];
                                  [SVProgressHUD showSuccessWithStatus:@"获取成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
}



#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [babyList count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 获取当前section的名称，据此获取到当前section的数量。
    NSString *sectionType = [sectionArr objectAtIndex:section];
    NSArray *list = [babyList objectForKey:sectionType];
    if (nil == list) {
        return 0;
    }
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //NSString *sectionType = [sectionArr objectAtIndex:indexPath.section];
    //NSArray *list = [babyList objectForKey:sectionType];
    
    BabyListCell * babyListCell = (BabyListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
   
    // 取当前section，设置单元格显示内容。
    NSInteger section = indexPath.section;
    // 获取这个分组的名称，再根据名称获得这个列表。
    NSString *sectionType = [sectionArr objectAtIndex:section];
    NSArray *list = [babyList objectForKey:sectionType];
//   [list objectAtIndex:indexPath.row];
    
    
    //babyListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//        [[[list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"baby_name"]
//    [[list objectAtIndex:indexPath.row] objectForKey:@"baby_name"]

//    babyListCell.babyImage.image = [UIImage imageNamed:@""];
        babyListCell.babyNameLabel.text = [NSString stringWithFormat:@"%@",[[list objectAtIndex:indexPath.row] objectForKey:@"baby_name"]];
        babyListCell.babyOldLabel.text = [NSString stringWithFormat:@"%@",[[list objectAtIndex:indexPath.row] objectForKey:@"birthday"]];
    if ([[[list objectAtIndex:indexPath.row] objectForKey:@"sex"] intValue] == 0) {
        babyListCell.babySexImage.image = [UIImage imageNamed:@"main_girl.png"];
    }
    else
    {
         babyListCell.babySexImage.image = [UIImage imageNamed:@"main_boy.png"];
    }

    
    return babyListCell;
    
}
// 这个方法用来告诉表格第section分组的名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionType = [sectionArr objectAtIndex:section];
    return sectionType;
    
}

// 设置section标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BabyHomePageViewController *babyHomePageVC = [[BabyHomePageViewController alloc] init];
    [self.navigationController pushViewController:babyHomePageVC animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
