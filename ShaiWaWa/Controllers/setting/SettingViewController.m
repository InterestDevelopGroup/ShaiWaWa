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
#import "HttpService.h"
#import "UserDefault.h"
#import "SVProgressHUD.h"

#import "Setting.h"
@interface SettingViewController ()
{
    Setting *setInfo;
    __block NSString *isRemind;
}
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
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    NSLog(@"%@",@{@"uid":user.uid});
    [[HttpService sharedInstance] getUserSetting:@{@"uid":user.uid} completionBlock:^(id object) {
        setInfo = [object copy];
        [_setListTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:@"获取成功"];
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
    
    //NSLog(@"%@",isRemind);
    
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
    // 获取这个分组的名称，再根据名称获得这个列表。
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
    [switchBtn addTarget:self action:@selector(changeCurrentStatus:) forControlEvents:UIControlEventValueChanged];
    
//    Setting *set = [self setBlockObj:^(id obj){
//        
//            return set_obj;
//        }];
        Setting *setIn = [[UserDefault sharedInstance] set];
        if (section == 0) {
            //        [cell.contentView addSubview:switchBtn];
            //        [label removeFromSuperview];
            label.hidden = YES;
            switchBtn.hidden = NO;
            
//            switchBtn.on = [set.is_remind isEqualToString:@"1"] ?: !switchBtn.on;
            if (indexPath.row == 0) {
                switchBtn.on = [setIn.is_remind isEqualToString:@"1"];
                switchBtn.tag = 4000;
            }
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            if (indexPath.row == 1) {
                //            [switchBtn removeFromSuperview];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                switch ([setIn.visibility intValue]) {
                    case 1:
                       label.text = @"所有都可见";
                        break;
                    case 2:
                        label.text = @"仅好友可见";
                        break;
                    case 3:
                        label.text = @"仅父母可见";
                        break;
                    default:
                        break;
                }
                
                label.font = [UIFont systemFontOfSize:12];
                label.textColor = [UIColor darkGrayColor];
                //            [cell.contentView addSubview:label];
                switchBtn.hidden = YES;
                label.hidden = NO;
            }
            if (indexPath.row == 2) {
                switchBtn.on = [setIn.show_position isEqualToString:@"1"];
                switchBtn.tag = 4002;
            }
            
        }
        if (section == 1) {
            switchBtn.on = [setIn.is_share isEqualToString:@"1"];
            switchBtn.tag = 4100;
        }
        if (section == 2) {
            switch (indexPath.row) {
                case 0:
                    switchBtn.on = [setIn.upload_video_only_wifi isEqualToString:@"1"];
                    switchBtn.tag = 4200;
                    break;
                case 1:
                    switchBtn.on = [setIn.upload_audio_only_wifi isEqualToString:@"1"];
                    switchBtn.tag = 4201;
                    break;
                case 2:
                    switchBtn.on = [setIn.upload_image_only_wifi isEqualToString:@"1"];
                    switchBtn.tag = 4202;
                    break;
                default:
                    break;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Setting *set = [[UserDefault sharedInstance] set];
    NSString *strOne;
    NSString *strTwo;
    if ([set.visibility isEqualToString:@"1"]) {
        strOne = @"仅好友可见";
        strTwo = @"仅父母可见";
    }
    if ([set.visibility isEqualToString:@"2"]) {
        strOne = @"所有都可见";
        strTwo = @"仅父母可见";
    }
    if ([set.visibility isEqualToString:@"3"]) {
        strOne = @"所有都可见";
        strTwo = @"仅好友可见";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:strOne,strTwo,@"取消",nil];
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSInteger section = indexPath.section;
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                case 1:
                    [actionSheet showFromRect:CGRectMake(0, 0, 320, 200) inView:self.view animated:YES];
                    break;
                case 2:
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 2:
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 3:
            
            break;
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    Setting *set = [[UserDefault sharedInstance] set];
    
    if ([set.visibility isEqualToString:@"1"]) {
        switch (buttonIndex) {
            case 0:
                set.visibility = @"2";
                break;
            case 1:
                set.visibility = @"3";
                break;
            
            default:
                break;
        }
    }
    else
    {
    if ([set.visibility isEqualToString:@"2"]) {
        switch (buttonIndex) {
            case 0:
                set.visibility = @"1";
                break;
            case 1:
                set.visibility = @"3";
                break;
                
            default:
                break;
        }
    }
    else
    {
    if ([set.visibility isEqualToString:@"3"]) {
        switch (buttonIndex) {
            case 0:
                set.visibility = @"1";
                break;
            case 1:
                set.visibility = @"2";
                break;
                
            default:
                break;
        }
    }
    }
    }
    
    
    set.userInfo = [[UserDefault sharedInstance] userInfo];
    set.is_remind = [[UserDefault sharedInstance] set].is_remind;
    set.show_position = [[UserDefault sharedInstance] set].show_position;
    set.is_share = [[UserDefault sharedInstance] set].is_share;
    set.upload_audio_only_wifi = [[UserDefault sharedInstance] set].upload_audio_only_wifi;
    set.upload_video_only_wifi = [[UserDefault sharedInstance] set].upload_video_only_wifi;
    set.upload_image_only_wifi = [[UserDefault sharedInstance] set].upload_image_only_wifi;
    [[UserDefault sharedInstance] setSet:set];
    [self getRefreshData];
    [self updateSetting];
}
- (void)changeCurrentStatus:(UISwitch *)swithBtn
{
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    Setting *set = [[UserDefault sharedInstance] set];
    switch (swithBtn.tag) {
        case 4000:
            if (swithBtn.on) {
                set.is_remind = @"1";
            }
            else
            {
                set.is_remind = @"0";
            }
            break;
        case 4002:
            if (swithBtn.on) {
                set.show_position = @"1";
            }
            else
            {
                set.show_position = @"0";
            }
            break;
        case 4100:
            if (swithBtn.on) {
                set.is_share = @"1";
            }
            else
            {
                set.is_share = @"0";
            }
            break;
        case 4200:
            if (swithBtn.on) {
                set.upload_video_only_wifi = @"1";
            }
            else
            {
                set.upload_video_only_wifi = @"0";
            }
            break;
        case 4201:
            if (swithBtn.on) {
                set.upload_image_only_wifi = @"1";
            }
            else
            {
                set.upload_image_only_wifi = @"0";
            }
            break;
        case 4202:

            if (swithBtn.on) {
                set.upload_audio_only_wifi = @"1";
            }
            else
            {
                set.upload_audio_only_wifi = @"0";
            }
            break;
        default:
            break;
    }
    set.userInfo = user;
    [[UserDefault sharedInstance] setSet:set];
    [self getRefreshData];
    
    [self updateSetting];
    
    
    
}

#pragma mark -- refresh List
- (void)getRefreshData
{
    [[UserDefault sharedInstance] set];
    [_setListTableView reloadData];
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
- (IBAction)quitCurAccountEvent:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[UserDefault sharedInstance] setUserInfo:nil];
}


- (void)updateSetting
{
    Setting *setting = [[UserDefault sharedInstance] set];
    
    NSLog(@"%@",@{@"uid":[[UserDefault sharedInstance] userInfo].uid,@"is_remind":setting.is_remind,@"visibility":setting.visibility,@"show_position":setting.show_position,@"is_share":setting.is_share,@"upload_video_only_wifi":setting.upload_video_only_wifi,@"upload_audio_only_wifi":setting.upload_audio_only_wifi,@"upload_image_only_wifi":setting.upload_image_only_wifi});
    
    [[HttpService sharedInstance] updateUserSetting:@{@"uid":[[UserDefault sharedInstance] userInfo].uid,  @"is_remind":setting.is_remind,@"visibility":setting.visibility,@"show_position":setting.show_position,@"is_share":setting.is_share,@"upload_video_only_wifi":setting.upload_video_only_wifi,@"upload_audio_only_wifi":setting.upload_audio_only_wifi,@"upload_image_only_wifi":setting.upload_image_only_wifi}completionBlock:^(id object) {
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        [SVProgressHUD showErrorWithStatus:responseString];
    }];
}
@end
