//
//  UserInfoPageViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "UserInfoPageViewController.h"
#import "UIViewController+BarItemAdapt.h"

#import "UserGenderUpdateViewController.h"
#import "UpdatePwdViewController.h"
#import "UserDefault.h"

@interface UserInfoPageViewController ()

@end

@implementation UserInfoPageViewController

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
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    updateUserVC = [[UpdateUserNameViewController alloc] init];
//    [updateUserVC setUsernameTextBlock:^(NSString *name)
//    {
//        
//    }];
    users = [[UserDefault sharedInstance] userInfo];
    self.title = users.username;
    userNameVal = users.username;
    if ([users.sex isEqualToString:@"0"]) {
        sexVal = @"保密";
    }
    else if([users.sex isEqualToString:@"1"])
    {
        sexVal = @"男";
    }
    else if([users.sex isEqualToString:@"2"])
    {
        sexVal = @"女";
    }
    pwdVal = @"";
     keyOfvalue = [[NSMutableArray alloc] initWithObjects:userNameVal,sexVal,pwdVal, nil];
    [_userInfoTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private Methods
- (void)initUI
{
    users = [[UserDefault sharedInstance] userInfo];
    
    self.title = users.username;
    [self setLeftCusBarItem:@"square_back" action:nil];
    key = [[NSMutableArray alloc] initWithObjects:@"用户名",@"性别",@"修改密码", nil];
    userNameVal = users.username;
    NSLog(@"%@",users.sex);
    if ([users.sex isEqualToString:@"0"]) {
        sexVal = @"保密";
    }
    else if([users.sex isEqualToString:@"1"])
    {
        sexVal = @"男";
    }
    else if([users.sex isEqualToString:@"2"])
    {
        sexVal = @"女";
    }
    pwdVal = @"";
    
    keyOfvalue = [[NSMutableArray alloc] initWithObjects:userNameVal,sexVal,pwdVal, nil];
    [_userInfoTableView clearSeperateLine];
    UIImage *img = [[UIImage imageNamed:@"main_2-bg2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    _userInfoTableView.backgroundView = imgView;
    if (3*80 < _userInfoTableView.bounds.size.height) {
        _userInfoTableView.frame = CGRectMake(12, 12, 299,3*40);
    }
}

#pragma mark - UITableView DataSources and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        UILabel *lblValue = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width-130, 5, 80, 30)];
        lblValue.tag = 777;
        lblValue.backgroundColor = [UIColor clearColor];
        lblValue.font = [UIFont systemFontOfSize:15.0];
        lblValue.textColor = [UIColor darkGrayColor];
        lblValue.textAlignment = NSTextAlignmentRight;
        [cell addSubview:lblValue];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [key objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    UILabel *val = (UILabel *)[cell viewWithTag:777];
    val.text = [keyOfvalue objectAtIndex:indexPath.row];
    //    cell.headPicView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"baby_mama.png"]];
    //    cell.nickNameLabel.text = @"张氏";
    //    cell.countOfBabyLabel.text = @"1个宝宝";
    //    cell.remarksLabel.text = @"孩子他妈";
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //UpdateUserNameViewController *updateUser = [[UpdateUserNameViewController alloc] init];
        updateUserVC.userName = [keyOfvalue objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:updateUserVC animated:YES];
    }
    if (indexPath.row == 1) {
        UserGenderUpdateViewController * genderVC = [[UserGenderUpdateViewController alloc] init];
        [self.navigationController pushViewController:genderVC animated:YES];
    }
    if (indexPath.row == 2) {
        UpdatePwdViewController * pwdVC = [[UpdatePwdViewController alloc] init];
        [self.navigationController pushViewController:pwdVC animated:YES];
    }
}
@end
