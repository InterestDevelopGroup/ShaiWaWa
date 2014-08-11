//
//  MyCollectionViewController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-8-11.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "DynamicCell.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
#import "BabyInfo.h"

@interface MyCollectionViewController ()
{
     NSMutableArray *dyArray;
}
@end

@implementation MyCollectionViewController

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
    self.title = @"我的收藏";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_myFavoriveList clearSeperateLine];
    [_myFavoriveList registerNibWithName:@"DynamicCell" reuseIdentifier:@"Cell"];
    //获取收藏的宝宝动态
    UserInfo *users = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getFavorite:@{@"uid":users.uid,@"offset":@"0",@"pagesize":@"10"} completionBlock:^(id object) {
        dyArray = [object objectForKey:@"result"];
        [_myFavoriveList reloadData];
        [SVProgressHUD showSuccessWithStatus:@"获取收藏成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
}

#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dyArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    //    dynamicCell.babyNameLabel.text = [[dyArray objectAtIndex:indexPath.row] objectForKey:@""];
    
    
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
//    [dynamicCell.zanButton addTarget:self action:@selector(praiseDYEvent:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [dynamicCell.praiseUserFirstBtn addTarget:self action:@selector(showPraiseListVC) forControlEvents:UIControlEventTouchUpInside];
//    [dynamicCell.praiseUserSecondBtn addTarget:self action:@selector(showPraiseListVC) forControlEvents:UIControlEventTouchUpInside];
//    [dynamicCell.praiseUserThirdBtn addTarget:self action:@selector(showPraiseListVC) forControlEvents:UIControlEventTouchUpInside];
//    [dynamicCell.moreBtn addTarget:self action:@selector(showShareGrayView:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [dynamicCell.topicBtn addTarget:self action:@selector(showTopicOfDyVC) forControlEvents:UIControlEventTouchUpInside];
    /*
     // 取当前section，设置单元格显示内容。
     NSInteger section = indexPath.section;
     // 获取这个分组的省份名称，再根据省份名称获得这个省份的城市列表。
     NSString *sectionType = [sectionArr objectAtIndex:section];
     NSArray *list = [babyList objectForKey:sectionType];
     [list objectAtIndex:indexPath.row];
     */
    //babyListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    babyListCell.babyImage.image = [UIImage imageNamed:@""];
    //    babyListCell.babyNameLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babyOldLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babySexImage.image = [UIImage imageNamed:@""];
    
    return dynamicCell;
    
}
@end
