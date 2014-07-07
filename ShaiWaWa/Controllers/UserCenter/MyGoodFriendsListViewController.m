//
//  MyGoodFriendsListViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "MyGoodFriendsListViewController.h"
#import "UIViewController+BarItemAdapt.h"

@interface MyGoodFriendsListViewController ()

@end

@implementation MyGoodFriendsListViewController

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
    self.title = @"我的好友";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UIImage *img = [[UIImage imageNamed:@"main_2-bg2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    _goodFriendListTableView.backgroundView = imgView;
    
    if (11*80 < _goodFriendListTableView.bounds.size.height) {
        _goodFriendListTableView.frame = CGRectMake(20, 60, 285,11*80);
    }
}

#pragma mark - UITableView DataSources and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return  11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    cell.textLabel.text = [[UIFont familyNames] objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
@end
