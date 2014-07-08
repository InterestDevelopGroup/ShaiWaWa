//
//  LocationsViewController.m
//  ShaiWaWa
//
//  Created by 祥 on 14-7-8.
//  Copyright (c) 2014年 helloworld. All rights reserved.
//

#import "LocationsViewController.h"
#import "UIViewController+BarItemAdapt.h"
#import "UIView+CutLayer.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController

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
    self.title = @"我在这里";
    [self setLeftCusBarItem:@"square_back" action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除位置" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 10, 60, 30)];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //[btn addTarget:self action:@selector(<#(id)#>) forControlEvents:UIControlEventTouchUpInside];
    [btn changeLayerToRoundWithCornerRadius:4.0 MasksToBounds:YES BorderWidth:0];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
   
    
    addrNames = [[NSMutableArray alloc] initWithObjects:@"建华酒店花木店",@"富春饭店",@"上海小南国",@"欧德咖啡", nil];
    addrDetails = [[NSMutableArray alloc] initWithObjects:@"上海市 浦东新区 梅花路591号",@"上海市 浦东新区 长柳路100号",@"上海市 浦东新区 花木路1378号",@"上海市 浦东新区 花木路999号", nil];
    [_addrTableView clearSeperateLine];
    
}

#pragma mark - UITableView DataSources and Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [addrNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.text = [addrNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.textColor = [UIColor darkGrayColor];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.text = [addrDetails objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _addrField.text = [addrNames objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
@end
