//
//  SearchAddressListViewController.m
//  ShaiWaWa
//
//  Created by Carl on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SearchAddressListViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "AddressBook.h"
#import "HttpService.h"
#import "SVProgressHUD.h"
#import "ContactUser.h"
#import "SearchGoodFriendsViewController.h"
#import "AppMacros.h"
#import "UserInfo.h"
#import "UserDefault.h"
#import "InputHelper.h"
@import MessageUI;
@interface SearchAddressListViewController ()<MFMessageComposeViewControllerDelegate>
@property (nonatomic,strong) RHAddressBook *ab;
@property (nonatomic,strong) NSArray * allPersons;
@property (nonatomic,strong) NSMutableArray * isAuthedFriends;
@property (nonatomic,strong) NSMutableArray * notAuthedFriends;
@property (nonatomic,strong) NSMutableArray * invitationFriends;
@end

@implementation SearchAddressListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _allPersons = @[];
        _isAuthedFriends = [@[] mutableCopy];
        _notAuthedFriends = [@[] mutableCopy];
        _invitationFriends = [@[] mutableCopy];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Private Methods
- (void)initUI
{
    self.title = @"通讯录好友";
    [self setLeftCusBarItem:@"square_back" action:@selector(backAtion:)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:[NSString stringWithFormat:@"邀请(%i)",0] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 60, 30)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn addTarget:self action:@selector(YaoQing) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    sectionArr = [[NSArray alloc] initWithObjects:@"待关注好友",@"可邀请好友", nil];


    [_addrListTableView clearSeperateLine];
    [_addrListTableView registerNibWithName:@"AddrBookCell" reuseIdentifier:@"Cell"];
    
    
    _ab = [[RHAddressBook alloc] init];
    //if not yet authorized, force an auth.
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusNotDetermined){
        [_ab requestAuthorizationWithCompletion:^(bool granted, NSError *error) {
            
    
            if([_ab numberOfPeople] > 0)
            {
                [self uploadContacts];
            }

            
        }];
    }
    
    // warn re being denied access to contacts
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"当前不能访问通讯录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    
    // warn re restricted access to contacts
    if ([RHAddressBook authorizationStatus] == RHAuthorizationStatusRestricted){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"当前不能访问通讯录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
    }
    
    if([RHAddressBook authorizationStatus] == RHAuthorizationStatusAuthorized)
    {
        if([_ab numberOfPeople] > 0)
        {
            [self uploadContacts];
        }
    }

}

- (void)backAtion:(id)sender
{
    NSArray * vcs = self.navigationController.viewControllers;
    
    for(UIViewController * vc in vcs)
    {
        if([vc isKindOfClass:[SearchGoodFriendsViewController class]])
        {
            [self.navigationController popToViewController:vc animated:YES];
            break ;
        }
    }
    
}


- (void)uploadContacts
{
    NSArray * people = [_ab peopleOrderedByUsersPreference];
    NSMutableArray * arr = [@[] mutableCopy];
    
    for(RHPerson * person in people)
    {
        NSString * phone = person.phoneNumbers.values[0];
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
        phone = [phone stringByReplacingOccurrencesOfString:@"+" withString:@""];
        if(phone == nil)
        {
            continue ;
        }
        NSDictionary * dic = @{@"name":person.name,@"phone":phone};
        [arr addObject:dic];
    }
    
    NSDictionary * dic = @{@"contacts":arr};
    
    [[HttpService sharedInstance] getAddressBookFriend:dic completionBlock:^(id object) {
        
        if(object == nil || [object count] == 0)
        {
            return ;
        }
        
        _allPersons = object;
        for(ContactUser * contact in object)
        {
            if([contact.is_auth isEqualToString:@"0"])
            {
                [_notAuthedFriends addObject:contact];
            }
            else
            {
                [_isAuthedFriends addObject:contact];
            }
        }
        
        [_addrListTableView reloadData];
        
    } failureBlock:^(NSError *error, NSString *responseString) {
        NSString * msg = responseString;
        if(error)
        {
            msg = @"获取失败.";
        }
        [SVProgressHUD showErrorWithStatus:msg];
    }];
}

- (void)YaoQing
{
    if([_invitationFriends count] == 0)
    {
        [SVProgressHUD showErrorWithStatus:@"请选择要邀请的好友."];
        return ;
    }
    
    NSMutableArray * phones = [@[] mutableCopy];
    for(ContactUser * contact in _invitationFriends)
    {
        [phones addObject:contact.phone];
    }
    
    [self sendSMS:Invitation_Msg_Content recipientList:phones];
}


- (void)btnSelected:(UIButton *)button
{
    AddrBookCell * cell ;
    if([button.superview.superview.superview isKindOfClass:[AddrBookCell class]])
    {
        cell = (AddrBookCell *)button.superview.superview.superview;
    }
    else if([button.superview.superview isKindOfClass:[AddrBookCell class]])
    {
        cell = (AddrBookCell *)button.superview.superview;
    }
    else
    {
        cell = (AddrBookCell *)button.superview;
    }
    
    NSIndexPath * indexPath = [_addrListTableView indexPathForCell:cell];
    if(indexPath.section == 0)
    {
        ContactUser * contact = _isAuthedFriends[indexPath.row];
        UserInfo * user = [[UserDefault sharedInstance] userInfo];
        
        [[HttpService sharedInstance] applyFriend:@{@"uid":user.uid,@"friend_id":contact.uid,@"remark":@"申请好友"} completionBlock:^(id object) {
            
            [SVProgressHUD showSuccessWithStatus:@"已发送申请."];
            
        } failureBlock:^(NSError *error, NSString *responseString) {
            NSString * msg = responseString;
            if(error)
            {
                msg = @"申请失败.";
            }
            [SVProgressHUD showErrorWithStatus:msg];
        }];
    }
    else
    {
        ContactUser * contact = _notAuthedFriends[indexPath.row];
        if([_invitationFriends containsObject:contact])
        {
            [_invitationFriends removeObject:contact];
        }
        else
        {
            [_invitationFriends addObject:contact];
        }
        
        UIButton * btn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
        [btn setTitle:[NSString stringWithFormat:@"邀请(%i)",[_invitationFriends count]] forState:UIControlStateNormal];
    }
}



//调用sendSMS函数
//内容，收件人列表
- (void)sendSMS:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients
{
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
        
    {
        controller.body = bodyOfMessage;
        controller.recipients = recipients;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:^{}];
    }
    
}

- (IBAction)searchAction:(id)sender
{
    [_searchField resignFirstResponder];
    NSString * keyword = [InputHelper trim:_searchField.text];
    if([InputHelper isEmpty:keyword])
    {
        //[SVProgressHUD showErrorWithStatus:@"请输入关键字"];
        return ;
    }
    
    NSMutableArray * tmp = [@[] mutableCopy];
    for(ContactUser * contact in _notAuthedFriends)
    {
        NSRange range = [contact.name rangeOfString:keyword];
        if(range.location != NSNotFound)
        {
            [tmp addObject:contact];
        }
    }
    
    _notAuthedFriends = tmp;
    
    tmp = [@[] mutableCopy];
    
    for(ContactUser * contact in _isAuthedFriends)
    {
        NSRange range = [contact.name rangeOfString:keyword];
        if(range.location != NSNotFound)
        {
            [tmp addObject:contact];
        }
    }
    
    _isAuthedFriends = tmp;
    
    [_addrListTableView reloadData];
    
    
    
}



#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [_isAuthedFriends count];
    }
    return [_notAuthedFriends count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddrBookCell * addrBookCell = (AddrBookCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    addrBookCell.selectionStyle = UITableViewCellEditingStyleNone;
    addrBookCell.isAddBtn_Selected = NO;
    ContactUser * contact ;
    if (indexPath.section == 1)
    {
        contact = _notAuthedFriends[indexPath.row];
        [addrBookCell.addFriendButton setImage:[UIImage imageNamed:@"jiahaoyou2.png"] forState:UIControlStateNormal];
        isSelectedBtn = addrBookCell.isAddBtn_Selected;
        [addrBookCell.addFriendButton setSelected:NO];
        [addrBookCell.addFriendButton addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        contact = _isAuthedFriends[indexPath.row];
        [addrBookCell.addFriendButton setImage:[UIImage imageNamed:@"jiahaoyou.png"] forState:UIControlStateNormal];
        [addrBookCell.addFriendButton addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    addrBookCell.nameLabel.text = contact.name;
    addrBookCell.phoneNumLabel.text = contact.phone;
    
    
    return addrBookCell;
    
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
    return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}



#pragma mark - MFMessageComposeViewControllerDelegate Methods

// 处理发送完的响应结果
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    if (result == MessageComposeResultCancelled)
    {
        NSLog(@"Message cancelled");
    }
    else if (result == MessageComposeResultSent)
    {
        NSLog(@"Message sent");
        [_invitationFriends removeAllObjects];
        UIButton * btn = (UIButton *)self.navigationItem.rightBarButtonItem.customView;
        [btn setTitle:[NSString stringWithFormat:@"邀请(%i)",[_invitationFriends count]] forState:UIControlStateNormal];
    }
    else
    {
        NSLog(@"Message failed");
        [SVProgressHUD showErrorWithStatus:@"发送失败."];
    }
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction:nil];
    return YES;
}

@end
