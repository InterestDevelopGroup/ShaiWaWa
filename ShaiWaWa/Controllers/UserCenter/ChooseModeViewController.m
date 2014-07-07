//
//  ChooseModeViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-5.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ChooseModeViewController.h"
#import "ControlCenter.h"

@interface ChooseModeViewController ()

@end

@implementation ChooseModeViewController

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


    UIBarButtonItem * leftItem = [self customBarItem:@"square_cebinlan" action:nil size:CGSizeMake(40, 30) imageEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIImageView *titileImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"square_shaiwawa"]];
    self.navigationItem.titleView = titileImage;
    UIBarButtonItem * rightItem_1 = [self customBarItem:@"square_yanjing" action:nil];
    UIBarButtonItem * rightItem_2 = [self customBarItem:@"square_pinglun-4" action:nil];
    self.navigationItem.rightBarButtonItems = @[rightItem_2,rightItem_1];
    
}
- (IBAction)showAddBabyVC:(id)sender
{
    [ControlCenter pushToAddBabyVC];
}
@end
