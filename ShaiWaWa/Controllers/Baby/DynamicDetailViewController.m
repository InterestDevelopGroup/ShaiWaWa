//
//  DynamicDetailViewController.m
//  ShaiWaWa
//
//  Created by Carl_Huang on 14-7-17.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "DynamicDetailViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "PinLunCell.h"
#import "DynamicHeadView.h"

@interface DynamicDetailViewController ()

@end

@implementation DynamicDetailViewController

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
    self.title = @"动态详情";
    [self setLeftCusBarItem:@"square_back" action:nil];
    [_pinLunListTableView clearSeperateLine];
    [_pinLunListTableView registerNibWithName:@"PinLunCell" reuseIdentifier:@"Cell"];
    UIImageView *scollBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 299, 145)];
    scollBgView.image = [UIImage imageNamed:@"square_pic-3.png"];
    
    UIImageView *bgImgView = [[UIImageView alloc] init];
    bgImgView.image = [UIImage imageNamed:@"baby_4-bg-2.png"];
    [_pinLunListTableView setBackgroundView:bgImgView];
    DynamicHeadView *dynamicHeadView = [[DynamicHeadView alloc] initWithFrame:CGRectMake(0, 0, _pinLunListTableView.bounds.size.width, 360)];
    [dynamicHeadView.imgOrVideoScrollView addSubview:scollBgView];
    [_pinLunListTableView setTableHeaderView:dynamicHeadView];
}



#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PinLunCell * pinLunListCell = (PinLunCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
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
    
    return pinLunListCell;
    
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
