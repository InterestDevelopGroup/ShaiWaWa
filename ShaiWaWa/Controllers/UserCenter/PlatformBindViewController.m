//
//  PlatformBindViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-10.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "PlatformBindViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "PlatformCell.h"

#import "UserDefault.h"
#import "UserInfo.h"
@interface PlatformBindViewController ()
{
    UserInfo *users;
}
@end

@implementation PlatformBindViewController

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
    self.title = @"社交平台绑定";
    [self setLeftCusBarItem:@"square_back" action:nil];
    
    users = [[UserDefault sharedInstance] userInfo];
    
    UIImage *img = [[UIImage imageNamed:@"main_2-bg2.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    _platformListTableView.backgroundView = imgView;
    [_platformListTableView registerNibWithName:@"PlatformCell" reuseIdentifier:@"Cell"];
    [_platformListTableView clearSeperateLine];
    if (3*80 < _platformListTableView.bounds.size.height) {
        _platformListTableView.frame = CGRectMake(11, 10, 299,3*40);
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
    PlatformCell *cell = (PlatformCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    switch (indexPath.row) {
        case 0:
            if (users.weibo == nil) {
                cell.platformCurBindButton.hidden = YES;
                cell.platformNameLabel.text = @"新浪";
            }
            else
            {
                
            }
            
            break;
        case 1:
            if (users.qq == nil) {
                cell.platformIconView.image = [UIImage imageNamed:@"qq.png"];
                cell.platformNameLabel.text = @"QQ";
                [cell.platformCurBindButton setImage:[UIImage imageNamed:@"bangding.png"] forState:UIControlStateNormal];
            }
            else
            {
                cell.platformIconView.image = [UIImage imageNamed:@"qq.png"];
                cell.platformNameLabel.text = @"";
                [cell.platformCurBindButton setImage:[UIImage imageNamed:@"jiebaoding.png"] forState:UIControlStateNormal];
            }
            break;
        case 2:
            if (users.wechat == nil) {
                cell.platformIconView.image = [UIImage imageNamed:@"dianhua2.png"];
                cell.platformNameLabel.text = @"手机";
               [cell.platformCurBindButton setImage:[UIImage imageNamed:@"bangding.png"] forState:UIControlStateNormal];
            }
            else
            {
                cell.platformIconView.image = [UIImage imageNamed:@"dianhua2.png"];
                cell.platformNameLabel.text = @"";
                [cell.platformCurBindButton setImage:[UIImage imageNamed:@"jiebaoding.png"] forState:UIControlStateNormal];
            }
            break;
        default:
            break;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
@end
