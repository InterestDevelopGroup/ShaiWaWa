//
//  ShaiWaSquareViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-7.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "ShaiWaSquareViewController.h"
#import "UIViewController+BarItemAdapt.h"

@interface ShaiWaSquareViewController ()

@end

@implementation ShaiWaSquareViewController

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
    self.title = @"晒娃广场";
    isHot = YES;
    isNew = NO;
    [self setLeftCusBarItem:@"square_back" action:nil];
    //UICollectionView
}

- (IBAction)hotSelected:(id)sender
{
    isHot = YES;
    isNew = NO;
    [_theHotButton setImage:[UIImage imageNamed:@"square_zuire.png"] forState:UIControlStateNormal];
    [_theNewButton setImage:[UIImage imageNamed:@"square_zuixin-.png"] forState:UIControlStateNormal];
}

- (IBAction)newSelected:(id)sender
{
    isHot = NO;
    isNew = YES;
    [_theHotButton setImage:[UIImage imageNamed:@"square_zuire-.png"] forState:UIControlStateNormal];
    [_theNewButton setImage:[UIImage imageNamed:@"square_zuixin.png"] forState:UIControlStateNormal];
}

#pragma mark - UICollection Delegate and DataSources

@end
