//
//  SettingViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "OSHelper.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    self.title = @"设置";
    [self setLeftCusBarItem:@"square_back" action:nil];
    sectionArr = [[NSArray alloc] initWithObjects:@"1",@"自动分享设置",@"仅在WIFI环境下上传",@"2", nil];
    basicSetList = [[NSMutableArray alloc] initWithObjects:@"新消息提醒",@"记录默认可见范围",@"记录默认附加位置信息", nil];
    autoShareSetList = [[NSMutableArray alloc] initWithObjects:@"自动分享到绑定社交平台", nil];
    onlyUploadInWifiSetList = [[NSMutableArray alloc] initWithObjects:@"视频",@"图片",@"声音", nil];
    otherSetList = [[NSMutableArray alloc] initWithObjects:@"推荐给好友",@"当前版本 1.03",@"关于", nil];
    
    setAllList = [[NSMutableArray alloc] initWithObjects:basicSetList,autoShareSetList,onlyUploadInWifiSetList,otherSetList, nil];
    setList = [[NSDictionary alloc] initWithObjects:setAllList forKeys:sectionArr];
    
    if (![OSHelper iOS7])
    {
        _quitCurBtn.frame = CGRectMake(10, 0, 253, 41);
    }
   
    
    [_setListTableView setTableFooterView:_customFootView];
}

#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [setAllList count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 获取当前section的名称，据此获取到当前section的数量。
    NSString *sectionType = [sectionArr objectAtIndex:section];
    NSArray *list = [setList objectForKey:sectionType];
    if (nil == list) {
        return 0;
    }
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
       
        UISwitch *switchButton = [[UISwitch alloc] init];
        UILabel *txtLabel = [[UILabel alloc] init];
        if ([OSHelper iOS7])
        {
            switchButton.frame = CGRectMake(tableView.bounds.size.width-60, 5, 60, 30);
            txtLabel.frame = CGRectMake(cell.bounds.size.width-136, 7, 100, 30);
        }
        else
        {
            switchButton.frame = CGRectMake(tableView.bounds.size.width-106, 5, 60, 30);
            txtLabel.frame = CGRectMake(cell.bounds.size.width-154, 6, 100, 30);
        }
        switchButton.tag = 8888;
        [cell.contentView addSubview:switchButton];
        
        
        txtLabel.tag = 6666;
        txtLabel.backgroundColor = [UIColor clearColor];
        //txtLabel.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:txtLabel];
        
        
    }
    NSInteger section = indexPath.section;
    // 获取这个分组的省份名称，再根据省份名称获得这个省份的城市列表。
    NSString *sectionType = [sectionArr objectAtIndex:section];
    NSArray *list = [setList objectForKey:sectionType];
    cell.textLabel.text = [list objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
//    cell.backgroundColor = [UIColor clearColor];
    UISwitch * switchBtn = (UISwitch * )[cell viewWithTag:8888];
    UILabel *label = (UILabel *)[cell viewWithTag:6666];
        //[cell.contentView addSubview:switchBtn];
    if (section == 0) {
//        [cell.contentView addSubview:switchBtn];
//        [label removeFromSuperview];
        label.hidden = YES;
        switchBtn.hidden = NO;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row == 1) {
//            [switchBtn removeFromSuperview];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                label.text = @"仅好友可见";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor darkGrayColor];
//            [cell.contentView addSubview:label];
            switchBtn.hidden = YES;
            label.hidden = NO;
        }
        
    }
    if (section == 3) {
//        [switchBtn removeFromSuperview];
//        [label removeFromSuperview];
        cell.accessoryType = UITableViewCellAccessoryNone;
        switchBtn.hidden = YES;
        label.hidden = YES;
        if (indexPath.row == 1) {
            label.text = @"已经是最新版本";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor lightGrayColor];
//            [cell.contentView addSubview:label];
            label.hidden = NO;
        }
    }
    
    

    return cell;
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
    
    
}

// 这个方法用来告诉表格第section分组的名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionType = [sectionArr objectAtIndex:section];
    [sectionType sizeWithFont:[UIFont systemFontOfSize:13]];
    if (section == 3) {
        sectionType = nil;
    }
    if (section == 0) {
        sectionType = nil;
    }
    return sectionType;
    
    
}

// 设置section标题高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    tableView.sectionIndexColor = [UIColor clearColor];
    NSString *sectionType = [sectionArr objectAtIndex:section];
    if (sectionType.length < 2) {
        if (section == 0) {
            return 0;
        }
        else
        return 15;
    }
    else
    return 30.0f;
}
- (IBAction)quitCurAccountEvent:(id)sender {
}
@end
