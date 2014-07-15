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

@interface PlatformBindViewController ()

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
   
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
@end
