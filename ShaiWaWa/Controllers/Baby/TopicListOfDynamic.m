//
//  TopicListOfDynamic.m
//  ShaiWaWa
//
//  Created by Cheung on 14-7-20.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "TopicListOfDynamic.h"
#import "UIViewController+BarItemAdapt.h"
#import "DynamicCell.h"
#import "DynamicDetailViewController.h"


#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"
@interface TopicListOfDynamic ()

@end

@implementation TopicListOfDynamic

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

    self.title = @"话题1";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_dynamicPageTableView clearSeperateLine];
    [_dynamicPageTableView registerNibWithName:@"DynamicCell" reuseIdentifier:@"Cell"];
    
    [[HttpService sharedInstance] getRecordByTopic:@{@"topic":self.title,@"offset":@"1",@"pagesize":@"10"} completionBlock:^(id object) {
        
        [SVProgressHUD showSuccessWithStatus:@"加载完成"];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell * dynamicCell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
//    [dynamicCell.praiseUserFirstBtn addTarget:self action:@selector(showPraiseListVC) forControlEvents:UIControlEventTouchUpInside];
//    [dynamicCell.praiseUserSecondBtn addTarget:self action:@selector(showPraiseListVC) forControlEvents:UIControlEventTouchUpInside];
//    [dynamicCell.praiseUserThirdBtn addTarget:self action:@selector(showPraiseListVC) forControlEvents:UIControlEventTouchUpInside];
//    [dynamicCell.moreBtn addTarget:self action:@selector(showShareGrayView) forControlEvents:UIControlEventTouchUpInside];
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DynamicDetailViewController *dynamicDetailVC = [[DynamicDetailViewController alloc] init];
    [self.navigationController pushViewController:dynamicDetailVC animated:YES];
}
@end
