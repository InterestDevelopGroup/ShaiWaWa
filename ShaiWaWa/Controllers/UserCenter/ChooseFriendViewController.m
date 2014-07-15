//
//  ChooseFriendViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChooseFriendViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "FriendSelectedCell.h"

@interface ChooseFriendViewController ()

@end

@implementation ChooseFriendViewController

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
    self.title = @"@谁";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UIButton *addFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addFriendButton setTitle:@"完成" forState:UIControlStateNormal];
    addFriendButton.frame = CGRectMake(0, 0, 40, 30);
    [addFriendButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
    UIBarButtonItem *right_addFriend = [[UIBarButtonItem alloc] initWithCustomView:addFriendButton];
    self.navigationItem.rightBarButtonItem = right_addFriend;
    
    [_friendSelectListTableView clearSeperateLine];
    [_friendSelectListTableView registerNibWithName:@"FriendSelectedCell" reuseIdentifier:@"Cell"];
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendSelectedCell * friendSelectedListCell = (FriendSelectedCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    //babyListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    babyListCell.babyImage.image = [UIImage imageNamed:@""];
    //    babyListCell.babyNameLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babyOldLabel.text = [NSString stringWithFormat:@""];
    //    babyListCell.babySexImage.image = [UIImage imageNamed:@""];
    friendSelectedListCell.backgroundColor = [UIColor clearColor];
    return friendSelectedListCell;
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
