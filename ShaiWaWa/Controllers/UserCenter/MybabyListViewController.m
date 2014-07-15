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

@interface MybabyListViewController ()

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
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BabyListCell * babyListCell = (BabyListCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //babyListCell.selectionStyle = UITableViewCellSelectionStyleNone;
//    babyListCell.babyImage.image = [UIImage imageNamed:@""];
//    babyListCell.babyNameLabel.text = [NSString stringWithFormat:@""];
//    babyListCell.babyOldLabel.text = [NSString stringWithFormat:@""];
//    babyListCell.babySexImage.image = [UIImage imageNamed:@""];
    
    return babyListCell;
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_babyListTableView deselectRowAtIndexPath:indexPath animated:YES];
    BabyHomePageViewController *babyHomePageVC = [[BabyHomePageViewController alloc] init];
    [self.navigationController pushViewController:babyHomePageVC animated:YES];
    
}
@end
