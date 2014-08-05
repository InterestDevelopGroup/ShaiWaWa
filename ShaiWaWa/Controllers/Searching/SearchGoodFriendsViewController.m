//
//  SearchGoodFriendsViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SearchGoodFriendsViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "ControlCenter.h"
#import "SearchRSViewController.h"
#import "SearchWeiboFriendViewController.h"
#import "SearchQQFriendViewController.h"
#import "SearchAddressBookViewController.h"
#import "ScannerQRCodeViewController.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"

@interface SearchGoodFriendsViewController ()

@end

@implementation SearchGoodFriendsViewController

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
    self.title = @"查找好友";
    [self setLeftCusBarItem:@"square_back" action:nil];
    typeOfFriendsArry = [[NSMutableArray alloc] initWithObjects:@"新浪微博上的好友",@"QQ好友",@"手机通讯录好友",@"微信邀请好友",@"扫描二维码", nil];
    typeIconArry = [[NSMutableArray alloc] initWithObjects:@"main_xinlang.png",@"qq.png",@"dianhua2.png",@"main_weixin.png",@"qrcode.png", nil];
    [_typeOfFriendsTableView clearSeperateLine];
    [_typeOfFriendsTableView setBounces:NO];
    [_typeOfFriendsTableView setScrollEnabled:NO];

//    
//    [_friendSelectListTableView clearSeperateLine];
//    [_friendSelectListTableView registerNibWithName:@"FriendSelectedCell" reuseIdentifier:@"Cell"];
}
#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [typeOfFriendsArry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([[typeIconArry objectAtIndex:indexPath.row] length] > 0) {
            UIImageView *typeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[typeIconArry objectAtIndex:indexPath.row]]];
            typeIcon.frame = CGRectMake(30, 15, 28, 23);
            typeIcon.tag = 9929;
            [cell addSubview:typeIcon];
            
        }
        UILabel *typeName = [[UILabel alloc] initWithFrame:CGRectMake(74, 15, 180, 30)];
        typeName.backgroundColor = [UIColor clearColor];
        typeName.text = [typeOfFriendsArry objectAtIndex:indexPath.row];
        typeName.tag = 9939;
        typeName.textColor = [UIColor darkGrayColor];
        [cell addSubview:typeName];
       
    }
    UIImageView *Icon = (UIImageView *)[cell viewWithTag:9929];
    Icon.image = [UIImage imageNamed:[typeIconArry objectAtIndex:indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *lblName = (UILabel *)[cell viewWithTag:9939];
    lblName.text = [typeOfFriendsArry objectAtIndex:indexPath.row];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchWeiboFriendViewController *weiBoVC = [[SearchWeiboFriendViewController alloc] init];
    SearchQQFriendViewController *qqFriendVC= [[SearchQQFriendViewController alloc] init];
    SearchAddressBookViewController *addressBookVC =[[SearchAddressBookViewController alloc] init];
    ScannerQRCodeViewController *scannCodeCardVC = [[ScannerQRCodeViewController alloc] init];
    
    int num = indexPath.row;
    switch (num) {
        case 0:
            [self.navigationController pushViewController:weiBoVC animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:qqFriendVC animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:addressBookVC animated:YES];
            break;
        case 3:
//            [self.navigationController pushViewController:<#(UIViewController *)#> animated:YES];
            break;
        case 4:
           [self.navigationController pushViewController:scannCodeCardVC animated:YES];
            break;
        default:
            break;
    }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (_searchField.text.length > 0) {
        [textField resignFirstResponder];
        SearchRSViewController *searchRS = [[SearchRSViewController alloc] init];
        searchRS.searchValue = _searchField.text;
        _searchField.text = nil;
        [self.navigationController pushViewController:searchRS animated:YES];
        
    }
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)startSearch:(id)sender
{
    if (_searchField.text.length > 0) {
        [_searchField resignFirstResponder];
        SearchRSViewController *searchRS = [[SearchRSViewController alloc] init];
        searchRS.searchValue = _searchField.text;
        [self.navigationController pushViewController:searchRS animated:YES];
        
    }
}
@end
