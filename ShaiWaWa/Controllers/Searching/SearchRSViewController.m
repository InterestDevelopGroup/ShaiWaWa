//
//  SearchRSViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "SearchRSViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "SearchRSCell.h"

#import "HttpService.h"
#import "SVProgressHUD.h"
#import "UserDefault.h"
#import "UserInfo.h"
#import "Friend.h"

@interface SearchRSViewController ()

@end

@implementation SearchRSViewController
@synthesize searchValue;
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
    [_searchRSListTableView clearSeperateLine];
    [_searchRSListTableView registerNibWithName:@"SearchRSCell" reuseIdentifier:@"Cell"];
    _searchRSField.text = searchValue;
    UserInfo *user = [[UserDefault sharedInstance] userInfo];
    [[HttpService sharedInstance] searchFriend:@{@"uid":user.uid,
                                                 @"keyword":_searchRSField.text,
                                                 @"offset":@"1",
                                                 @"pagesize":@"10"} completionBlock:^(id object) {
                                                     [SVProgressHUD showSuccessWithStatus:@"搜索完成"];
                                                 } failureBlock:^(NSError *error, NSString *responseString) {
                                                     [SVProgressHUD showErrorWithStatus:responseString];
                                                 }];
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchRSCell * resultListCell = (SearchRSCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //babyListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    babyListCell.babyImage.image = [UIImage imageNamed:@""];
    //    babyListCell.babyNameLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babyOldLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babySexImage.image = [UIImage imageNamed:@""];
    resultListCell.backgroundColor = [UIColor clearColor];
    resultListCell.addButton.tag = indexPath.row;
    [resultListCell.addButton addTarget:self action:@selector(addLom:) forControlEvents:UIControlEventTouchUpInside];
    return resultListCell;
    
}

- (void)addLom:(UIButton *)btn
{
    DDLogInfo(@"%i",btn.tag);
}
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
