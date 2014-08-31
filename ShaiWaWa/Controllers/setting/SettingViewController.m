//
//  SettingViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SettingViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "LoginViewController.h"
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
}


#pragma mark - Private Methods
- (void)initUI
{
    self.title = NSLocalizedString(@"SettingVCTitle", nil);
    [self setLeftCusBarItem:@"square_back" action:nil];
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] getUserSetting:@{@"uid":user.uid} completionBlock:^(id object) {
        setInfo = [object copy];
        [_setListTableView reloadData];
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"LoadFinish", nil)];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
    
    
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
    UISwitch * switchBtn = (UISwitch * )[cell viewWithTag:8888];
    UILabel *label = (UILabel *)[cell viewWithTag:6666];
    [switchBtn addTarget:self action:@selector(changeCurrentStatus:) forControlEvents:UIControlEventValueChanged];
    

    Setting *setIn = [[UserDefault sharedInstance] set];
    if (section == 0) {
        label.hidden = YES;
        switchBtn.hidden = NO;
        if (indexPath.row == 0) {
            switchBtn.on = [setIn.is_remind isEqualToString:@"1"];
            //switchBtn.tag = 4000;
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (indexPath.row == 1) {
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
            switchBtn.hidden = YES;
            label.hidden = NO;
        }
        if (indexPath.row == 2) {
            switchBtn.on = [setIn.show_position isEqualToString:@"1"];
        }
        
    }
    if (section == 1) {
        switchBtn.on = [setIn.is_share isEqualToString:@"1"];
    }
    if (section == 2) {
        switch (indexPath.row) {
            case 0:
                switchBtn.on = [setIn.upload_video_only_wifi isEqualToString:@"1"];
                break;
            case 1:
                switchBtn.on = [setIn.upload_image_only_wifi isEqualToString:@"1"];
                break;
            case 2:
                switchBtn.on = [setIn.upload_audio_only_wifi isEqualToString:@"1"];
                break;
            default:
                break;
        }
    }

    if (section == 3) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        switchBtn.hidden = YES;
        label.hidden = YES;
        if (indexPath.row == 1) {
            label.text = @"已经是最新版本";
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = [UIColor lightGrayColor];
            label.hidden = NO;
        }
    }

    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Setting *set = [[UserDefault sharedInstance] set];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSInteger section = indexPath.section;
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(section == 0 && indexPath.row == 1)
    {
        NSString *strOne = @"所有都可见";
        NSString *strTwo = @"仅亲友可见";
        NSString *strThree = @"仅父母可见";
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择:" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:strOne,strTwo,strThree,nil];
        [actionSheet showFromRect:CGRectMake(0, 0, 320, 200) inView:self.view animated:YES];
    }
    else
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
}


#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 3) {
        return ;
    }
    
     Setting *set = [[UserDefault sharedInstance] set];
    if(buttonIndex == [set.visibility intValue] - 1)
    {
        return ;
    }
    
    if(buttonIndex == 0)
    {
        set.visibility = @"1";
    }
    else if(buttonIndex == 1)
    {
        set.visibility = @"2";
    }
    else if(buttonIndex == 2)
    {
        set.visibility = @"3";
    }
    
    
//    set.userInfo = [[UserDefault sharedInstance] userInfo];
//    set.is_remind = [[UserDefault sharedInstance] set].is_remind;
//    set.show_position = [[UserDefault sharedInstance] set].show_position;
//    set.is_share = [[UserDefault sharedInstance] set].is_share;
//    set.upload_audio_only_wifi = [[UserDefault sharedInstance] set].upload_audio_only_wifi;
//    set.upload_video_only_wifi = [[UserDefault sharedInstance] set].upload_video_only_wifi;
//    set.upload_image_only_wifi = [[UserDefault sharedInstance] set].upload_image_only_wifi;
    [[UserDefault sharedInstance] setSet:set];
    [self getRefreshData];
    [self updateSetting];
}




#pragma mark - refresh List
- (void)getRefreshData
{
    [_setListTableView reloadData];
}


- (void)changeCurrentStatus:(UISwitch *)swithBtn
{
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    Setting *set = [[UserDefault sharedInstance] set];
    
    UITableViewCell * cell;
    if([swithBtn.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell *)swithBtn.superview.superview;
    }
    else if([swithBtn.superview.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        cell = (UITableViewCell *)swithBtn.superview.superview.superview;
    }
    else
    {
        cell = (UITableViewCell *)swithBtn.superview;
    }
    
    NSIndexPath * indexPath = [_setListTableView indexPathForCell:cell];
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        if([set.is_remind isEqualToString:[NSString stringWithFormat:@"%i",swithBtn.on]])
        {
            return ;
        }
        set.is_remind = [NSString stringWithFormat:@"%i",swithBtn.on];
    }
    
    if(indexPath.section == 0 && indexPath.row == 2)
    {
        if([set.show_position isEqualToString:[NSString stringWithFormat:@"%i",swithBtn.on]])
        {
            return ;
        }
        set.show_position = [NSString stringWithFormat:@"%i",swithBtn.on];
    }
    
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        if([set.is_share isEqualToString:[NSString stringWithFormat:@"%i",swithBtn.on]])
        {
            return ;
        }
        set.is_share = [NSString stringWithFormat:@"%i",swithBtn.on];
    }
    
    if(indexPath.section == 2 && indexPath.row == 0)
    {
        if([set.upload_video_only_wifi isEqualToString:[NSString stringWithFormat:@"%i",swithBtn.on]])
        {
            return ;
        }
        set.upload_video_only_wifi = [NSString stringWithFormat:@"%i",swithBtn.on];
    }
    
    if(indexPath.section == 2 && indexPath.row == 1)
    {
        if([set.upload_image_only_wifi isEqualToString:[NSString stringWithFormat:@"%i",swithBtn.on]])
        {
            return ;
        }
        set.upload_image_only_wifi = [NSString stringWithFormat:@"%i",swithBtn.on];
    }
    
    if(indexPath.section == 2 && indexPath.row == 2)
    {
        if([set.upload_audio_only_wifi isEqualToString:[NSString stringWithFormat:@"%i",swithBtn.on]])
        {
            return ;
        }
        set.upload_audio_only_wifi = [NSString stringWithFormat:@"%i",swithBtn.on];
    }
    
    set.userInfo = user;
    [[UserDefault sharedInstance] setSet:set];
    [self getRefreshData];
    [self updateSetting];
    
    
    
}

- (IBAction)quitCurAccountEvent:(id)sender
{
    [[UserDefault sharedInstance] setUserInfo:nil];
    LoginViewController * vc = [[LoginViewController alloc] initWithNibName:nil bundle:nil];
    self.navigationController.viewControllers = @[vc];
    vc = nil;
}


- (void)updateSetting
{
    Setting *setting = [[UserDefault sharedInstance] set];
    
    //NSLog(@"%@",@{@"uid":[[UserDefault sharedInstance] userInfo].uid,@"is_remind":setting.is_remind,@"visibility":setting.visibility,@"show_position":setting.show_position,@"is_share":setting.is_share,@"upload_video_only_wifi":setting.upload_video_only_wifi,@"upload_audio_only_wifi":setting.upload_audio_only_wifi,@"upload_image_only_wifi":setting.upload_image_only_wifi});
    
    [[HttpService sharedInstance] updateUserSetting:@{@"uid":[[UserDefault sharedInstance] userInfo].uid,  @"is_remind":setting.is_remind,@"visibility":setting.visibility,@"show_position":setting.show_position,@"is_share":setting.is_share,@"upload_video_only_wifi":setting.upload_video_only_wifi,@"upload_audio_only_wifi":setting.upload_audio_only_wifi,@"upload_image_only_wifi":setting.upload_image_only_wifi}completionBlock:^(id object) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"SetSuccess", nil)];
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = NSLocalizedString(@"LoadError", nil);
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}
@end
