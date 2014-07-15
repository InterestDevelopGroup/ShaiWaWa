//
//  SearchAddressListViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SearchAddressListViewController.h"
#import "UIViewController+BarItemAdapt.h"


@interface SearchAddressListViewController ()

@end

@implementation SearchAddressListViewController

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
    self.title = @"通讯录好友";
    [self setLeftCusBarItem:@"square_back" action:nil];
    numOfYaoQing = 0;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:[NSString stringWithFormat:@"邀请(%i)",numOfYaoQing] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 60, 30)];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
//    [btn setImage:<#(UIImage *)#> forState:<#(UIControlState)#>];
//    [btn setBackgroundImage:<#(UIImage *)#> forState:<#(UIControlState)#>];
    [btn addTarget:self action:@selector(YaoQing) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    sectionArr = [[NSArray alloc] initWithObjects:@"待关注好友",@"可邀请好友", nil];
    waitToCardList = [[NSArray alloc] initWithObjects:@"1",@"3",@"5",@"7", nil];
    mayYaoQiList =  [[NSArray alloc] initWithObjects:@"2",@"4",@"6",@"8", nil];
    friendsAll = [NSArray arrayWithObjects:waitToCardList,mayYaoQiList, nil];
    //以段名数组，段数据为参数创建数据资源用的字典实例
    freindsList = [[NSDictionary alloc] initWithObjects:friendsAll forKeys:sectionArr];
    
    //[_babyListTableView clearSeperateLine];
    //[_babyListTableView registerNibWithName:@"BabyListCell" reuseIdentifier:@"Cell"];
    [_addrListTableView clearSeperateLine];
    [_addrListTableView registerNibWithName:@"AddrBookCell" reuseIdentifier:@"Cell"];
}



#pragma mark - UITableView DataSources and Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [freindsList count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 获取当前section的名称，据此获取到当前section的数量。
    NSString *sectionType = [sectionArr objectAtIndex:section];
    NSArray *list = [freindsList objectForKey:sectionType];
    if (nil == list) {
        return 0;
    }
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    addrBookCell = (AddrBookCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    addrBookCell.isAddBtn_Selected = NO;
    if (addrBookCell == nil) {
        addrBookCell = [[AddrBookCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
       
    }
    if (indexPath.section == 1) {
        [addrBookCell.addFriendButton setImage:[UIImage imageNamed:@"jiahaoyou2.png"] forState:UIControlStateNormal];
        isSelectedBtn = addrBookCell.isAddBtn_Selected;
        [addrBookCell.addFriendButton setSelected:NO];
        [addrBookCell.addFriendButton addTarget:self action:@selector(btnSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [addrBookCell.addFriendButton setImage:[UIImage imageNamed:@"jiahaoyou.png"] forState:UIControlStateNormal];
    }
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
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)YaoQing
{
    
}

- (void)btnSelected:(UIButton *)button
{
//    if (!button.isSelected)
//    {
//        
//      [button setImage:[UIImage imageNamed:@"jiahaoyou.png"] forState:UIControlStateNormal];
//      [button setSelected:YES];
//        isSelectedBtn = YES;
//    }
//    else
//    {
//        if (!isSelectedBtn) {
//            [button setImage:[UIImage imageNamed:@"jiahaoyou.png"] forState:UIControlStateNormal];
//            isSelectedBtn = YES;
//        }
//        else
//        {
//            [button setImage:[UIImage imageNamed:@"jiahaoyou2.png"] forState:UIControlStateNormal];
//            isSelectedBtn = NO;
//        }
//        [button setSelected:NO];
//    }
}
@end
